module teg.detail.tree;

// must use public imports as necessary due to mixin
public import teg.detail.parser;
public import teg.vector;
public import beard.variant;

// T... is the storing part of the parser
template TreeParser(NodeT, T...) {
    mixin parser!T;

    private alias stores!subparser  SubStores;
    alias Vector!SubStores          TreeType;

    // todo: sort this out
    static if (is(NodeT == void))
        alias Vector!SubStores value_type;
    else
        alias NodeT value_type;

    static if (isVariant!SubStores) {
        alias Variant!(value_type, TreeType, SubStores.types) cont_type;
    }
    else {
        alias Variant!(value_type, TreeType, SubStores) cont_type;
    }

}
