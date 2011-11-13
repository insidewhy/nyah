module teg.sequence;

import teg.detail.parser;
import teg.stores;
import teg.skip;

import beard.meta;

import std.typetuple;
import std.typecons;

// used for sequences storing tuples within sequences.
// if there is a way I can pass variadic alias parameters this can be
// done more optimally.
private struct OffsetView(size_t _offset, T) {
    enum offset = _offset;
    this(T tup) { tuple_ = &tup; }
    T *tuple_;
}

private template flattenAppend(alias T, U) {
    static if (is(U : void))
        alias T flattenAppend;
    else static if (isTuple!U)
        alias T.append!(U.Types) flattenAppend;
    else
        alias T.append!U flattenAppend;
}

private template sequenceStorage(T...) {
    static if (T.length == 0)
        alias void sequenceStorage;
    else static if (T.length == 1)
        alias T[0] sequenceStorage;
    else
        alias Tuple!T sequenceStorage;
}

private struct parseSeqIdx(size_t idx, P) {
    static bool skip(S, O)(S s, ref O o) {
        static if (isTuple!O)
            return P.parse(s, o[idx]);
        else
            return P.parse(s, o);
    }
}

private template makeIdxStorer(size_t idx, T...) {
    alias T types;

    template add(U) {
        static if (! storesSomething!U)
            alias makeIdxStorer!(idx, types, Skip!U)                    add;
        else static if (isTuple!(stores!U)) {
            static if (idx == 0)
                alias makeIdxStorer!(idx + (stores!U).length, types, U) add;
            else
                // todo: make parser at offset idx
                alias makeIdxStorer!(idx + (stores!U).length, types)    add;
        }
        else
            alias makeIdxStorer!(idx + 1, types, parseSeqIdx!(idx, U))  add;
    }
}

// This Sequence accepts an arguments on whether to skip whitespace between
// parsers in the sequence.
class Sequence(bool SkipWs, T...) {
    mixin whitespaceSkipper;
    mixin storingParser;

    private alias staticMap!(stores, T)  substores;

    private alias sequenceStorage!(
        foldLeft!(flattenAppend, TL!(), substores).types) value_type;

    alias foldLeft2!(makeIdxStorer!0u, T).types subparsers;

    static bool skip(S)(S s) {
        if (! T[0].skip(s)) return false;

        auto save = s.save();
        foreach (p; T[1..$]) {
            skip_whitespace(s);

            if (s.empty() || ! p.skip(s)) {
                s.restore(save);
                return false;
            }
        }

        return true;
    }

    // this used to be a subfunction of skip but the compiler chokes for
    // certain types
    private static bool skip_help(size_t pidx, S, O)(S s, ref O o) {
        if (! subparsers[pidx].skip(s, o))
            return false;

        static if (pidx < subparsers.length - 1) {
            skip_whitespace(s);
            return skip_help!(pidx + 1)(s, o);
        }
        else return true;
    }

    static bool skip(S, O)(S s, ref O o) {
        auto save = s.save();
        if (! skip_help!(0)(s, o)) {
            s.restore(save);
            return false;
        }
        return true;
    }
}

class Sequence(T...) if (T.length > 1) : Sequence!(true, T) {}

class Sequence(T) : T {}
