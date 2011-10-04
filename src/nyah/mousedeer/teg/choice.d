module teg.choice;

import teg.detail.parser;
import teg.stores;

import beard.meta;
import beard.variant;

private template choiceParser(alias S, P...) {
    static if (1 == S.types.length)
        alias S.types[0]         value_type;
    else
        alias Variant!(S.types)  value_type;

    alias P parsers;

    struct parseAs(SP) {
        alias stores!SP SS;

        static bool skip(S, O)(S s, ref O o) {
            static if (isVariant!O) {
                o = SS.init;
                return SP.skip(s, o.as!SS);
            }
            else return SP.skip(s, o);
        }
    }

    template add(U) {
        static if (! storesSomething!U)
            alias choiceParser!(S, P, parseAs!U) add;
        // static if (storesCharOrRange!U) {
        //     // TODO: if char or range also in Variant then merge to range
        //     alias choiceParser!(S, P, U) add;
        // }
        else alias choiceParser!(S.append!(stores!U), P, parseAs!U) add;
    }
}

class Choice(T...) if (T.length > 1) {
    mixin storingParser;

    private alias foldLeft2!(choiceParser!(TSet!()), T)  choiceFold;

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
