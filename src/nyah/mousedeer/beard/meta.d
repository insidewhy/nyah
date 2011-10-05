module beard.meta;

import std.typetuple;

// like TupleList but packs everything into one type
template TL(T...) {
    alias TypeTuple!(T) types;

    template append(U...) {
        alias TL!(T, U) append;
    }

    template contains(U) {
        enum contains = indexOf!U != -1;
    }

    template indexOf(U) {
        enum indexOf = staticIndexOf!(U, T);
    }
}

template TSet(T...) {
    mixin TL!T;

    template append(U) {
        static if (contains!U)
            alias TSet!T append;
        else
            alias TSet!(T, U) append;
    }

    private template add(alias U, V) { alias U.append!V add; }

    template append(U...) if (U.length > 1) {
        alias foldLeft!(add, TSet!T, U) append;
    }
}

template contains(N, T...) {
    enum contains = staticIndexOf!(N, T) != -1;
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
