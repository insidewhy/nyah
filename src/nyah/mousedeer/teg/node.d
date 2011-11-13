module teg.node;

import teg.tree_joined;
import teg.detail.parser : hasSubparser, storingParser;
import beard.io : printIndented;
import beard.meta : lastIndexOf;

template printNode() {
    void printTo(S)(int indent, S stream) {
        immutable name = typeid(this).name;
        stream.write(name[(lastIndexOf(name, '.') + 1)..$], ": ");
        printIndented(stream, indent, value_);
    }
}

template makeNode(P...) {
    alias void __IsNode;

    mixin hasSubparser!P;
    mixin storingParser;
    mixin printNode;

    // alias stores!subparser value_type;
    alias typeof(this) value_type;

    // nodes should always store but this static if allows the compiler
    // to give better error messages in case of compile-time errors
    static if (storesSomething!subparser)
        stores!subparser value_;

    static bool skip(S, O)(S s, ref O o) {
        return subparser.parse(s, o.value_);
    }
    static bool skip(S)(S s) { return subparser.skip(s); }
}

// Test if a parser is a pure (not tree) node type.
template isNode(T) {
    enum isNode = is(T.__IsNode);
}

////////////////////////////////////////////////////////////////////////////
// used to break cyclic type chains for self-referential parsers
class Node(T) {
    mixin hasSubparser!T;
    mixin storingParser;

    static bool skip(S)(S s) { return subparser.skip(s); }
    static bool skip(S, O)(S s, ref O o) { return subparser.skip(s, o); }
}

////////////////////////////////////////////////////////////////////////////
// tree stuff
private template makeTreeNode(T) {
    mixin storingParser;
    mixin printNode;

    alias T.value_type value_type;
    T.TreeType         value_;

    static bool skip(S)(S s) { return T.skip(s); }
    static bool skip(S, O)(S s, ref O o) { return T.skip(s, o); }
}

// specialisations of makeNode for tree type parsers
template makeNode(P : TreeJoined!(J, T), J, T...) {
    mixin makeTreeNode!(TreeJoined!(typeof(this), true, J, T));
}

template makeNode(P : TreeJoinedTight!(J, T), J, T...) {
    mixin makeTreeNode!(TreeJoined!(typeof(this), false, J, T));
}

