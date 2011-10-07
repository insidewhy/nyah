module teg.stores;

import teg.sequence;
import teg.range;
import teg.node;

template storesSomething(T) {
    enum storesSomething = is(T.value_type);
}

template storesSomething(T...) if (T.length > 1) {
    mixin storesSomething!(Sequence!T);
}

template stores(T) {
    static if (is(T Unused : Node!U, U))
        alias U stores;
    else static if (isNode!T)
        alias T stores;
    static if (storesSomething!T)
        alias T.value_type stores;
    else
        alias void stores;
}

template stores(T...) if (T.length > 1) {
    mixin stores!(Sequence!T);
}

template storesChar(T...) {
    enum storesChar = is(stores!(T) : char);
}

template storesRange(T...) {
    enum storesRange = is(stores!(T) : Range);
}

template storesCharOrRange(T...) {
    enum storesCharOrRange = storesRange!T || storesChar!T;
}

//////////////////////////////////////////////////////////////////////////////
// like stores but looser as returns what type the parser skips over for
// certain void storing parsers like Char.
template skips(T) {
    static if (__traits(hasMember, T, "SkippedParser"))
        alias T.SkippedParser skips;
    else
        alias T skips;
}
