module teg.sequence;

import teg.detail.parser;
import teg.stores;
import teg.skip;

import beard.meta;

import std.typetuple;
import std.typecons;

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

private template storeAtIdx(size_t idx) {
    bool skip(S, O)(S s, O o) if (isTuple!O) {
        // o[idx] = v;
        return true;
    }

    bool skip(S, O)(S s, O o) if (! isTuple!O) {
        // o = v;
        return true;
    }
}

private template makeIdxStorer(alias T, U) {
    static if (! stores_something!U)
        alias TL!(
            TL!(T.types[0].types, skip_!(U)),
            T.types[1] )                     makeIdxStorer;
    else static if (isTuple!(stores!U))
        alias TL!(
            T.types[0],
            T.types[1] + (stores!U).length ) makeIdxStorer;
    else
        alias TL!(
            TL!(T.types[0].types, storeAtIdx!(T.types[1])),
            T.types[1] + 1 )                 makeIdxStorer;
}

// This sequence accepts an arguments on whether to skip whitespace between
// parsers in the sequence.
class sequence(bool SkipWs, T...) {
    mixin whitespace_skipper;
    mixin storing_parser;

    private alias staticMap!(stores, T)  substores;

    private alias sequenceStorage!(
        foldLeft!(flattenAppend, TL!(), substores).types) value_type;

    alias foldLeft!(
        makeIdxStorer, TL!(TL!(), 0u), T).types[0] subparsers;

    static if (! is(value_type : void))
        value_type value_;

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

    static bool skip(S, O)(S s, ref O o) {
        bool help(size_t pidx)() {
            if (! subparsers.types[pidx].skip(s, o))
                return false;

            static if (pidx < subparsers.types.length - 1) {
                skip_whitespace(s);
                return help!(pidx + 1);
            }
            else return true;
        }

        auto save = s.save();
        if (! help!(0)) {
            s.restore(save);
            return false;
        }
        return true;
    }
}

class sequence(T...) if (T.length > 1) : sequence!(true, T) {}

class sequence(T) : T {}
