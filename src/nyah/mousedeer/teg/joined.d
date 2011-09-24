module teg.joined;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

import std.traits : Select;

// this version of joined accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class joined(bool SkipWs, bool AtLeastOne, J, T...) {
    mixin parser!T;

    vector!(stores!subparser) value_;

    static bool skip(S)(S s) {
        if (AtLeastOne) {
            if (! subparser.skip(s)) return false;
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty()) return false;
        }

        while (subparser.skip(s)) {
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty()) return false;
        };
        return false;
    }

    static bool skip(S, O)(S s, ref O o) {
        if (AtLeastOne) {
            if (! _skip(s, o)) {
                o.clear();
                return false;
            }
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty()) return false;
        }

        while (_skip(s, o)) {
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty()) return false;
        };

        return false;
    }

    private static bool _skip(S, O)(S s, ref O o) {
        subparser sub = new subparser();
        if (! sub.parse(s)) return false;
        o.push_back(sub.value_);

        return true;
    }
}

class joined_lexeme(J, T...) : joined!(false, false, J, T) {}
class joined(J, T...)  : joined!(true, false, J, T) {}

class joined_plus_lexeme(J, T...) : joined!(false, true, J, T) {}
class joined_plus(J, T...)  : joined!(true, true, J, T) {}
