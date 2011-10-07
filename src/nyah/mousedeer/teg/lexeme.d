module teg.lexeme;

import teg.sequence;
import beard.meta;

import teg.store;
import teg.stores;
import std.typetuple;

private template collapseTextInRange(R, T...) {
    alias TypeTuple!(T, R) types;

    template add(U) {
        static if (storesCharOrRange!U)
            alias collapseTextInRange!(R.add!U, T) add;
        else
            alias collapseText!(T, R, U) add;
    }
}

private template collapseText(T...) {
    alias T types;

    template add(U) {
        static if (storesCharOrRange!U)
            alias collapseTextInRange!(Store!U, T) add;
        else
            alias collapseText!(T, U) add;
    }
}

class Lexeme(T...) if (T.length > 1)
    : Sequence!(false, foldLeft2!(collapseText!(), T).types) {}

class Lexeme(T) : T {}
