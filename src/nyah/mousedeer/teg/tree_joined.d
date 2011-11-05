module teg.tree_joined;

import teg.detail.parser;
import teg.vector;
import teg.node;
import teg.joined;
import teg.stores;

private class TreeJoined(bool SkipWs, J, T...) {
    alias void __IsTreeParser;

    mixin parser!T;

    static if (isNode!subparser) {
        private alias subparser             joinedStore;
        private alias subparser.value_type  singleStore;
    }
    else {
        private alias stores!T singleStore;
        // private alias stores!T singleStore;
    }

    // incorrect from here
    alias Vector!joinedStore value_type;

    static bool skip(S, O)(S s, ref O o) {
        return Joined!(SkipWs, true, J, T).skip(s, o);
    }

    static bool skip(S)(S s) {
        return Joined!(SkipWs, true, J, T).skip(s);
    }
}

class TreeJoined(J, T...) : TreeJoined!(true, J, T) {}
class TreeJoinedTight(J, T...) : TreeJoined!(false, J, T) {}
