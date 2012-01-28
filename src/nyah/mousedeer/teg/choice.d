module teg.choice;

import teg.detail.parser;
import teg.stores;
import beard.meta;
import beard.variant;
import std.typetuple : staticMap;

private template choiceParser(alias S, bool CanBeEmpty, P...) {
    static if (1 == S.types.length) {
        private alias S.types[0] first;
        static if (CanBeEmpty) {
            static if (is(first == class) || __traits(hasMember, first, "length"))
                // if type can be null or type has a ".length" (assuming when
                // it is 0 the object is empty) then just store it.
                alias first          value_type;
            else
                // otherwise put into variant to allow it to be nulled.
                alias Variant!first  value_type;
        }
        else
            alias first          value_type;
    }
    else static if (! S.types.length)
        alias void               value_type;
    else
        alias Variant!(S.types)  value_type;

    alias P parsers;

    struct parseAs(SP) {
        alias stores!SP SS;

        static bool skip(S, O)(S s, ref O o) {
            static if (! storesSomething!SP)
                return SP.skip(s);
            else static if (isVariant!SS)
                return SP.skip(s, o);
            else static if (isVariant!O) {
                o = SS.init;
                return SP.parse(s, o.as!SS);
            }
            else return SP.parse(s, o);
        }
    }

    template add(U) {
        static if (! storesSomething!U)
            alias choiceParser!(S, true, P, parseAs!U) add;
        else static if (storesVariant!U)
            // collapse variant types into this
            alias choiceParser!(
                S.append!((stores!U).types), CanBeEmpty, P, parseAs!U) add;
        // static if (storesCharOrRange!U) {
        //     // todo: if char or range also in Variant then merge to range
        //     alias choiceParser!(S, CanBeEmpty, P, U) add;
        // }
        else
            alias choiceParser!(
                S.append!(stores!U), CanBeEmpty, P, parseAs!U) add;
    }
}

class Choice(T...) if (T.length > 1) {
    mixin storingParser;

    private alias foldLeft2!(choiceParser!(TSet!(), false),
                             staticMap!(skips, T))           choiceFold;

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

    alias choiceFold.value_type value_type;
}

class Choice(T) : T {}
