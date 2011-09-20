module beard.meta;

import beard.tuple;
import std.typetuple;

// like TupleList but packs everything into one type
template TL(T...) {
    alias TypeTuple!(T) values_t;
}

private template foldLeft(alias F, alias A) {
    alias A foldLeft;
}

private template foldLeft(alias F, alias A, H, T...) {
    alias foldLeft!(F, F!(A, H), T) foldLeft;
}
