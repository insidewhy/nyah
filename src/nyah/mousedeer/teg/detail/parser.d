module teg.detail.parser;

import teg.sequence;

template whitespace_skipper() {
    // optionally skip whitespace depending on available template parameter
    static void skip_whitespace(S)(S s) {
        static if (SkipWs) s.skip_whitespace();
    }
}

template storing_parser() {
    bool parse(S)(S s) {
        static if (__traits(compiles, new typeof(value_)))
            value_ = new typeof(value_);

        return skip(s, value_);
    }
}

template parser(T...) {
    mixin whitespace_skipper;
    mixin storing_parser;

    static if (T.length > 1)
        alias sequence!T subparser;
    else
        alias T[0] subparser;
}
