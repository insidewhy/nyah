module teg.joined;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

import std.traits : Select;
import std.stdio : writeln;

// this version of joined accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class joined(bool SkipWs, bool AtLeastOne, J, T...) {
    mixin parser!T;

    vector!(stores!subparser) value_;

    static bool skip(S)(S s) {
        if (! subparser.skip(s)) return ! AtLeastOne;

        for (;;) {
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty() || ! subparser.skip(s)) return false;
        };
    }

    static bool skip(S, O)(S s, ref O o) {
        if (! _skip(s, o)) return ! AtLeastOne;

        for (;;) {
            skip_whitespace(s);
            if (s.empty() || ! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty() || ! _skip(s, o)) return false;
        };
    }

    private static bool _skip(S, O)(S s, ref O o) {
        subparser sub = new subparser();
        if (! sub.parse(s)) return false;
        o.push_back(sub.value_);

        return true;
    }
}

class joined(J, T...)  : joined!(true, false, J, T) {}
// at least one T must be matched
class joined_plus(J, T...)  : joined!(true, true, J, T) {}

// tight versions do not allow whitespace around join strings
class joined_tight(J, T...) : joined!(false, false, J, T) {}
class joined_plus_tight(J, T...) : joined!(false, true, J, T) {}
