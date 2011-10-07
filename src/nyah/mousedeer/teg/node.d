module teg.node;

import teg.detail.parser : hasSubparser, storingParser;

template node(P...) {
    alias void __IsNode;

    mixin hasSubparser!P;
    mixin storingParser;

    static bool skip(S, O)(S s, ref O o) {
        return subparser.skip(s, o.value_);
    }

    stores!subparser value_;
}

template isNode(T) {
    enum isNode = is(T.__IsNode);
}
