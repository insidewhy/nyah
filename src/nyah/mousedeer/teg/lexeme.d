module teg.lexeme;

import teg.sequence;
import beard.meta;

import teg.store_range;
import teg.stores;
import std.typetuple;

private template collapseTextInRange(R, T...) {
    alias TypeTuple!(T, R) types;

    template add(U) {
        static if (stores_char_or_range!U)
            alias collapseTextInRange!(R.add!U, T) add;
        else
            alias collapseText!(T, R, U) add;
    }
}

private template collapseText(T...) {
    alias T types;

    template add(U) {
        static if (stores_char_or_range!U)
            alias collapseTextInRange!(store_range!U, T) add;
        else
            alias collapseText!(T, U) add;
    }
}

class lexeme(T...) if (T.length > 1)
    : sequence!(false, foldLeft2!(collapseText!(), T).types) {}

class lexeme(T) : T {}
