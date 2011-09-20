module teg.detail.parser;

import teg.sequence;

template parser(T...) {
    static if (T.length > 1)
        alias sequence!T subparser;
    else
        alias T[0] subparser;

    bool parse(S)(S s) {
        value_ = new typeof(value_);
        return skip(s, value_);
    }
}
