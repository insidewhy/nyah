module teg.stores;

import teg.sequence;

template stores_something(T) {
    immutable stores_something = is(typeof(T.value_));
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
    immutable stores_char = is(stores!(T) : char);
}
