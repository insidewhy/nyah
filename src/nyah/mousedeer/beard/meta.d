module beard.meta;

import std.typetuple;

// like TupleList but packs everything into one type
template TL(T...) {
    alias TypeTuple!(T) types;
}

private template foldLeft(alias F, alias A) {
    alias A foldLeft;
}

private template foldLeft(alias F, alias A, H, T...) {
    alias foldLeft!(F, F!(A, H), T) foldLeft;
}
