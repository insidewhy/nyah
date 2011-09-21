module teg.skip;

import teg.detail.parser;

class skip_(T) {
    mixin parser!T;

    static bool skip(S)(S s) { return subparser.skip(s); }
    static bool skip(S, O)(S s, ref O o) { return skip(s); }
}
