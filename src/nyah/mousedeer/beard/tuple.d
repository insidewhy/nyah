module beard.tuple;

import beard.meta;
import std.typetuple;

class is_tuple {}

class tuple(T...) : is_tuple {
    alias TypeTuple!(T) values_t;

    this(T t) {
        value = t;
    }

    values_t value;
}

auto ref get(int I, T : is_tuple)(T tup) {
    return tup.value[I];
}

auto make_tuple(T...)(T t) {
    return new tuple!(T)(t);
}

auto make_tuple(T)(T t) {
    return t;
}
