module teg.detail.tree;

// must use public imports as necessary due to mixin
public import teg.detail.parser;
public import teg.vector;
public import beard.variant;

// T... is the storing part of the parser
template TreeParser(NodeT, T...) {
    mixin parser!T;

  private:
    private alias stores!subparser  SubStores;
    alias Vector!SubStores          TreeType;

    static if (is(NodeT == void)) {
        alias SubStores StoresType;
        static auto ref getContainer(O)(ref O o) { return o; }
    }
    else {
        alias NodeT StoresType;
        static auto ref getContainer(O)(ref O o) { return o.value_; }
    }

  public:
    static if (isVariant!SubStores) {
        static auto ref getSubvalue(O)(ref O o) { return o; }
        alias Variant!(StoresType, SubStores.types) value_type;
    }
    else {
        static auto ref getSubvalue(O)(ref O o) { return o.as!SubStores; }
        alias Variant!(StoresType, SubStores) value_type;
    }

}
