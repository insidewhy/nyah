module teg.node;

import teg.detail.parser : hasSubparser, storingParser;
import beard.io;

template makeNode(P...) {
    alias void __IsNode;

    mixin hasSubparser!P;
    mixin storingParser;

    static bool skip(S, O)(S s, ref O o) {
        return subparser.skip(s, o.value_);
    }

    static bool skip(S)(S s) { return subparser.skip(s); }

    void printTo(S)(int indent, S stream) {
        stream.write(typeid(this).name, ": ");
        printIndented(stream, indent, value_);
    }

    alias stores!subparser value_type;
    value_type value_;
}

template isNode(T) {
    enum isNode = is(T.__IsNode);
}

// used for forward referencing a node
class Node(T) {
    mixin hasSubparser!T;
    mixin storingParser;

    static bool skip(S)(S s) { return subparser.skip(s); }

    static bool skip(S, O)(S s, ref O o) {
        return subparser.skip(s, o);
    }
}
