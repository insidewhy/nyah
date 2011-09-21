module teg.sequence;

import teg.detail.parser;
import teg.stores;

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

private template storeAtIdx(int idx) {
    bool exec(S)(S s) {
    }
}

private template makeIdxStorer(alias T, U) {
    static if (is(stores!U : void))
        alias T makeIdxStorer;
    else static if (isTuple!(stores!U))
        alias T makeIdxStorer; // todo: fix
    else
        alias TL!( T.types[0], T.types[1] + 1 ) makeIdxStorer;
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
        makeIdxStorer, TL!(TL!(), 0), T).types[0] subparsers;

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
        // todo: store that mother fucker
        foreach (p, idx; T) {
        }

        return false;
    }
}

class sequence(T...) if (T.length > 1) : sequence!(true, T) {}

class sequence(T) : T {}
