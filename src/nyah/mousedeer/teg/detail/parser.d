module teg.detail.parser;

import teg.sequence;

class parser(T...) {
    static if (T.length > 1)
        alias sequence!T subparser;
    else
        alias T[0] subparser;
}
