module teg.tree_joined;

import teg.detail.parser;
import teg.vector;
import teg.joined;
import teg.stores;

class TreeJoined(NodeT, bool SkipWs, J, T...) {
    alias void __IsTreeParser;

    mixin parser!T;

    static if (is(NodeT == void)) {
        private alias Vector!(stores!subparser) value_type;
    }
    else {
        private alias subparser             joinedStore;
        private alias subparser.value_type  singleStore;

        alias Vector!joinedStore value_type;
    }

    static bool skip(S, O)(S s, ref O o) {
        return Joined!(SkipWs, true, J, T).skip(s, o);
    }

    static bool skip(S)(S s) {
        return Joined!(SkipWs, true, J, T).skip(s);
    }
}

class TreeJoined(J, T...) : TreeJoined!(void, true, J, T) {}
class TreeJoinedTight(J, T...) : TreeJoined!(void, false, J, T) {}
