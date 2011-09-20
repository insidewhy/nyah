module teg.many;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

import std.stdio;

private class _many(bool SkipWs, bool AtLeastOne, T...) {
    mixin parser!T;

    static if (SkipWs) {
        vector!(stores!subparser) value_;
    }
    else {
        range value_;
    }

    static bool skip(S)(S s) {
        if (AtLeastOne) {
            if (! subparser.skip(s)) return false;
            if (SkipWs) s.skip_whitespace();
            if (s.empty()) return true;
        }

        while (subparser.skip(s)) {
            if (SkipWs) s.skip_whitespace();
            if (s.empty()) break;
        };
        return true;
    }

    static bool skip(S, O)(S s, ref O o) {
        static if (! SkipWs) {
            o.begin(s);

            if (AtLeastOne) {
                if (! subparser.skip(s)) return false;
                if (s.empty()) return true;
            }

            while (subparser.skip(s)) {
                if (s.empty()) break;
            };

            o.end();
            return true;
        }
        return false;
    }
}

class many_range(T...) : _many!(false, false, T) {}
class many_list(T...)  : _many!(true, false, T) {}
class many_plus_range(T...) : _many!(false, true, T) {}
class many_plus_list(T...)  : _many!(true, true, T) {}

class many(T...) {
    // if subparser stores char then range else list
}

class many_plus(T...) {
    // if subparser stores char then range else list
}
