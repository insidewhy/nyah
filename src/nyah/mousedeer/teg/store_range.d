module teg.store_range;

import teg.detail.parser;
import teg.range;
import teg.stores;

// force parsers to store a range but preserve storage of char if that is
// all the subparser stores.
class store_range(T...) {
    mixin parser!T;

    template add(U) { alias store_range!(T, U) add; }
    static bool skip(S)(S s) { return subparser.skip(s); }

    static if (stores_char!subparser) {
        static bool skip(S, O)(S s, ref O o) {
            foreach(P; T)
                if (! P.skip(s)) return false;
            return true;
        }

        char value_;
    }
    else {
        static bool skip(S, O)(S s, ref O o) {
            o.parsing(s);
            foreach(P; T) if (! P.skip(s)) {
                o.clear();
                return false;
            }
            o.parsed();
            return true;
        }

        range value_;
    }
}

