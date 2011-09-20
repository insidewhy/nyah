module teg.many;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

import std.traits : Select;

// this version of many accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class many(bool SkipWs, bool AtLeastOne, T...) {
    mixin parser!T;

    static if (SkipWs)
        vector!(stores!subparser) value_;
    else
        range value_;

    static bool skip(S)(S s) {
        if (AtLeastOne) {
            if (! subparser.skip(s)) return false;
            skip_whitespace(s);
            if (s.empty()) return true;
        }

        while (subparser.skip(s)) {
            skip_whitespace(s);
            if (s.empty()) break;
        };
        return true;
    }

    static bool skip(S, O)(S s, ref O o) {
        static if (! SkipWs) o.parsing(s);

        if (AtLeastOne) {
            _skip(s, o);
            skip_whitespace(s);
            if (s.empty()) return true;
        }

        while (_skip(s, o)) {
            skip_whitespace(s);
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
        else if (! subparser.skip(s)) return false;

        return true;
    }
}

class many_range(T...) : many!(false, false, T) {}
class many_list(T...)  : many!(true, false, T) {}

// many_plus parsers return false if the subparser matches zero times.
class many_plus_range(T...) : many!(false, true, T) {}
class many_plus_list(T...)  : many!(true, true, T) {}

// many_range is subparser stores char, else many_list
class many(T...) : Select!(stores_char!T, many_range!T, many_list!T) {}

// many_plus_range is subparser stores char, else many_plus_list
class many_plus(T...)
    : Select!(stores_char!T, many_plus_range!T, many_plus_list!T) {}
