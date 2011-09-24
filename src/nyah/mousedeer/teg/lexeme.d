module teg.lexeme;

import teg.sequence;
import beard.meta;

import teg.store_range;

private template collapseTextInRange(T...) {
}

private template collapseText(T...) {
    // todo: collapse adjacent char/range parsers
    alias T types;

    template add(U) {
        alias collapseText!(T, U) add;
    }
}

class lexeme(T...) if (T.length > 1)
    : sequence!(false, foldLeft2!(collapseText!(), T).types) {}

class lexeme(T) : T {}
