module teg.sequence;

import teg.detail.parser;
import teg.stores;

import beard.meta;
import beard.tuple;

import std.typetuple;

private template flattenAppend(alias T, U) {
    static if (is(U : void))
        alias T flattenAppend;
    else static if (is(U : is_tuple))
        alias TL!(T.values_t, U.values_t) flattenAppend;
    else
        alias TL!(T.values_t, U) flattenAppend;
}

private template sequenceStorage(T...) {
    static if (T.length == 0)
        alias void sequenceStorage;
    else static if (T.length == 1)
        alias T[0] sequenceStorage;
    else
        alias tuple!T sequenceStorage;
}

private template storeAtIdx(int idx, S) {
}

private template makeIdxStorer(alias T, U) {
    static if (is(U : void))
        alias T makeIdxStorer;
    else
        alias TL!( T.values_t[0], T.values_t[1] + 1 ) makeIdxStorer;
}

// This sequence accepts an arguments on whether to skip whitespace between
// parsers in the sequence.
class sequence(bool SkipWs, T...) {
    mixin whitespace_skipper;
    mixin storing_parser;

    private alias staticMap!(stores, T)  substores;

    private alias sequenceStorage!(
        foldLeft!(flattenAppend, TL!(), substores).values_t) value_type;

    alias foldLeft!(
        makeIdxStorer, TL!(string, -1), substores).values_t[0] subparsers;

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
