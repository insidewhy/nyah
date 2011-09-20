module teg.stores;

template stores_something(T) {
    static if (is(typeof(T.value_)))
        immutable stores_something = true;
    else
        immutable stores_something = false;
}

template stores(T) {
    static if (stores_something!T)
        alias typeof(T.value_) stores;
    else
        alias void stores;
}
