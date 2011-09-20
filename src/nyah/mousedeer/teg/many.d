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
        static if (! SkipWs) o.parsing(s);

        if (AtLeastOne) {
            _skip(s, o);
            static if (SkipWs) s.skip_whitespace();
            if (s.empty()) return true;
        }

        while (_skip(s, o)) {
            static if (SkipWs) s.skip_whitespace();
            if (s.empty()) break;
        };

        static if (! SkipWs) o.parsed();
        return true;
    }

    private static bool _skip(S, O)(S s, ref O o) {
        static if (SkipWs) {
            subparser sub = new subparser();
            if (! sub.parse(s)) return false;
            o.push_back(sub.value_);
        }
        else {
            if (! subparser.skip(s)) return false;
        }

        return true;
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
