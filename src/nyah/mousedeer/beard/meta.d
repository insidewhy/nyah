module beard.meta;

import std.typetuple;

// like TupleList but packs everything into one type
template TL(T...) {
    alias TypeTuple!(T) types;

    template append(U...) {
        alias TL!(T, U) append;
    }
}

private template foldLeft(alias F, alias A) {
    alias A foldLeft;
}

// like foldLeft but calls an inner template "add" on the first alias
// as template argument
template foldLeft2(alias F, T...) {
    alias foldLeft!(innerFold, F, T) foldLeft2;
}

private template foldLeft(alias F, alias A, H, T...) {
    alias foldLeft!(F, F!(A, H), T) foldLeft;
}

private template innerFold(alias T, U) {
    alias T.add!U innerFold;
}
