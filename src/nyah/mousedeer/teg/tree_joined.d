module teg.tree_joined;

import teg.detail.parser;
import teg.vector;
import teg.joined;
import teg.stores;

class TreeJoined(NodeT, bool SkipWs, J, T...) {
    alias void __IsTreeParser;

    mixin parser!T;

    // todo: sort this out
    static if (is(NodeT == void)) {
        alias Vector!(stores!subparser) value_type;
    }
    else {
        alias NodeT value_type;
        alias Vector!(stores!subparser) joined_type;
    }

    static bool skip(S, O)(S s, ref O o) {
        static if (is(NodeT == void))
            return Joined!(SkipWs, true, J, T).skip(s, o);
        else
            return Joined!(SkipWs, true, J, T).skip(s, o.value_);
    }

    static bool skip(S)(S s) {
        return Joined!(SkipWs, true, J, T).skip(s);
    }
}

class TreeJoined(J, T...) : TreeJoined!(void, true, J, T) {}
class TreeJoinedTight(J, T...) : TreeJoined!(void, false, J, T) {}
