module teg.choice;

import teg.detail.parser;
import teg.stores;

import beard.meta;
import beard.variant;

private template choiceParser(alias S, bool CanBeEmpty, P...) {
    static if (1 == S.types.length) {
        private alias S.types[0] first;
        static if (CanBeEmpty) {
            static if (is(first == class) || __traits(hasMember, first, "length")
                       || is(first == char)) // hack: see below
                alias first          value_type;
            else
                alias Variant!first  value_type;
        }
        else
            alias first          value_type;
    }
    else
        alias Variant!(S.types)  value_type;

    alias P parsers;

    struct parseAs(SP) {
        alias stores!SP SS;

        static bool skip(S, O)(S s, ref O o) {
            static if (! storesSomething!SP)
                return SP.skip(s);
            else static if (isVariant!O) {
                o = SS.init;
                return SP.skip(s, o.as!SS);
            }
            else return SP.skip(s, o);
        }
    }

    template add(U) {
        static if (! storesSomething!U)
            alias choiceParser!(S, true, P, parseAs!U) add;
        // static if (storesCharOrRange!U) {
        //     // TODO: if char or range also in Variant then merge to range
        //     alias choiceParser!(S, CanBeEmpty, P, U) add;
        // }
        // todo: collapse variants
        else alias choiceParser!(
            S.append!(stores!U), CanBeEmpty, P, parseAs!U) add;
    }
}

class Choice(T...) if (T.length > 1) {
    mixin storingParser;

    // todo: force char/range skipping parsers to store in choice.. see hack
    private alias foldLeft2!(choiceParser!(TSet!(), false), T)  choiceFold;

    alias choiceFold.parsers    subparsers;

    static bool skip(S)(S s) {
        foreach (P; T)
            if (P.skip(s)) return true;

        return false;
    }

    static bool skip(S, O)(S s, ref O o) {
        // parsers that can advance the stream restore it on error
        foreach (P; subparsers)
            if (P.skip(s, o)) return true;

        return false;
    }

    choiceFold.value_type value_;
}

class Choice(T) : T {}
