module teg.detail.tree;

// must use public imports as necessary due to mixin
public import teg.detail.parser;
public import teg.vector;
public import beard.variant;

// T... is the storing part of the parser
template TreeParser(bool LongIsNode, _LongStores, T...) {
    mixin parser!T;

    alias _LongStores LongStores;

  private:
    private alias stores!subparser  ShortStores;

    static if (LongIsNode)
        static ref getContainer(O)(ref O o) { return o.value_; }
    else
        static ref getContainer(O)(ref O o) { return o; }

  public:
    static if (isVariant!ShortStores) {
        static auto ref getSubvalue(O)(ref O o) { return o; }
        alias Variant!(LongStores, ShortStores.types) value_type;
    }
    else {
        static auto ref getSubvalue(O)(ref O o) { return o.as!ShortStores; }
        alias Variant!(LongStores, ShortStores) value_type;
    }

}
