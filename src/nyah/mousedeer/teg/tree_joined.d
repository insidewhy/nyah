module teg.tree_joined;

import teg.joined;
import teg.stores;
import teg.detail.tree;

class TreeJoined(NodeT, bool SkipWs, J, T...) {
    mixin TreeParser!(NodeT, T);

    static bool skip(S, O)(S s, ref O o) {
        //////////////////////
        static if (! isVariant!SubStores)
            o = SubStores.init;

        if (! subparser.parse(s, getSubvalue(o))) {
            o.reset();
            return false;
        }

        skip_whitespace(s);
        if (s.empty()) return true;
        auto save = s.save();
        if (! J.skip(s))  return true;
        skip_whitespace(s);

        SubStores second;
        if (s.empty() || ! subparser.parse(s, second)) {
            s.restore(save);
            return true;
        }

        StoresType v;
        create(v);
        getContainer(v).push_back(getSubvalue(o)).push_back(second);
        o = v;

        Joined!(SkipWs, false, J, T).skipTail(s, getContainer(v));
        return true;
    }

    static bool skip(S)(S s) {
        return Joined!(SkipWs, true, J, T).skip(s);
    }
}

class TreeJoined(J, T...) : TreeJoined!(void, true, J, T) {}
class TreeJoinedTight(J, T...) : TreeJoined!(void, false, J, T) {}
