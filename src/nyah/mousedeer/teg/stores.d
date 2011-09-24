module teg.stores;

import teg.sequence;
import teg.range;

template stores_something(T) {
    enum stores_something = is(typeof(T.value_));
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
    enum stores_char = is(stores!(T) : char);
}

template stores_range(T...) {
    enum stores_char = is(stores!(T) : range);
}

template stores_char_or_range(T...) {
    // d compiler bug:
    // enum stores_char_or_range = stores_range!T || stores_char!T;
    enum stores_char_or_range = is(stores!(T) : range) || is(stores!(T) : char);
}
