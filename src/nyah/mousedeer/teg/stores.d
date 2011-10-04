module teg.stores;

import teg.sequence;
import teg.range;

template storesSomething(T) {
    enum storesSomething = is(typeof(T.value_));
}

template storesSomething(T...) if (T.length > 1) {
    mixin storesSomething!(Sequence!T);
}

template stores(T) {
    static if (storesSomething!T)
        alias typeof(T.value_) stores;
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
    enum storesChar = is(stores!(T) : Range);
}

template storesCharOrRange(T...) {
    // d compiler bug:
    // enum storesCharOrRange = storesRange!T || storesChar!T;
    enum storesCharOrRange = is(stores!(T) : Range) || is(stores!(T) : char);
}
