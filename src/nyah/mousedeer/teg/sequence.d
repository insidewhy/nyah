module teg.sequence;

import teg.detail.parser;
import teg.stores;

import beard.meta;

import std.typetuple;

private template combineStorage(T, U) {
    static if (is(U:void))
        alias T combineStorage;
    else static if (is(T:void))
        alias U combineStorage;
    else
        alias void combineStorage;
}

private template sequenceStorage(T...) {
    alias foldLeft!(combineStorage, void, T)  sequenceStorage;
}

// This sequence accepts an arguments on whether to skip whitespace between
// parsers in the sequence.
class sequence(bool SkipWs, T...) {
    mixin whitespace_skipper;
    mixin storing_parser;

    alias sequenceStorage!(staticMap!(stores, T))  value_type;
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
    }
}

class sequence(T...) if (T.length > 1) : sequence!(true, T) {}

class sequence(T) : T {}
