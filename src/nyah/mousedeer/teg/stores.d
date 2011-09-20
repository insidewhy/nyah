module teg.stores;

import teg.sequence;

template stores_something(T) {
    static if (is(typeof(T.value_)))
        immutable stores_something = true;
    else
        immutable stores_something = false;
}

template stores_something(T...) if (T.length > 1) {
    mixin stores_something!(sequence!T);
}

template stores(T) {
    static if (stores_something!T)
        alias typeof(T.value_) stores;
    else
        alias void stores;
}

template stores(T...) if (T.length > 1) {
    mixin stores!(sequence!T);
}

template stores_char(T...) {
    static if (is(stores!(T) : char))
        immutable stores_char = true;
    else
        immutable stores_char = false;
}
