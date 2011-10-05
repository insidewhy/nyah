module teg.joined;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

// this version of joined accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class Joined(bool SkipWs, bool AtLeastOne, J, T...) {
    mixin parser!T;

    Vector!(stores!subparser) value_;

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

class Joined(J, T...)  : Joined!(true, false, J, T) {}
// at least one T must be matched
class JoinedPlus(J, T...)  : Joined!(true, true, J, T) {}

// tight versions do not allow whitespace around join strings
class JoinedTight(J, T...) : Joined!(false, false, J, T) {}
class JoinedPlusTight(J, T...) : Joined!(false, true, J, T) {}
