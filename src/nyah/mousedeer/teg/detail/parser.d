module teg.detail.parser;

import teg.sequence : Sequence;
import teg.stores;

template whitespaceSkipper() {
    // optionally skip whitespace depending on available template parameter
    static void skip_whitespace(S)(S s) {
        static if (SkipWs) s.skip_whitespace();
    }
}

template storingParser() {
    // like skip but creates the value to be stored if necessary
    static bool parse(S, O)(S s, ref O o) {
        static if (is(O : Object)) o = new O;
        return skip(s, o);
    }
}

template hasSubparser(T...) {
    static if (T.length > 1)
        alias Sequence!T subparser;
    else
        alias T[0] subparser;
}

template parser(T...) {
    mixin whitespaceSkipper;
    mixin storingParser;
    mixin hasSubparser!T;
}
