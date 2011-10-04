module teg.detail.parser;

import teg.sequence : sequence;
import teg.stores;

template whitespace_skipper() {
    // optionally skip whitespace depending on available template parameter
    static void skip_whitespace(S)(S s) {
        static if (SkipWs) s.skip_whitespace();
    }
}

template storing_parser() {
    // like skip but creates the value to be stored if necessary
    static bool parse(S, O)(S s, ref O o) {
        static if (is(O : Object))
            o = new O;

        return skip(s, o);
    }

    bool parse(S)(S s) { return parse(s, value_); }
}

template parser(T...) {
    mixin whitespace_skipper;
    mixin storing_parser;

    static if (T.length > 1)
        alias sequence!T subparser;
    else
        alias T[0] subparser;
}
