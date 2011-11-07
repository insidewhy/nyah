module teg.tree_joined;

import teg.joined;
import teg.stores;
import teg.detail.tree;

class TreeJoined(NodeT, bool SkipWs, J, T...) {
    mixin TreeParser!(NodeT, T);

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
