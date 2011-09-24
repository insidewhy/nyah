module teg.store_range;

import teg.detail.parser;
import teg.range;

class store_range(T...) {
    mixin parser!T;

    static bool skip(S, O)(S s, ref O o) {
        o.parsing(s);
        if (! subparser.skip(s)) {
            o.clear();
            return false;
        }
        o.parsed();
        return true;
    }

    range value_;
}

