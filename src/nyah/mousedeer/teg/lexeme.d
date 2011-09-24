module teg.lexeme;

import teg.sequence;
import beard.meta;

private class storeRange(T...) {
    mixin parser!T;

    static bool skip(S, O)(S s, ref O o) {
        o.parsing(s);
        if (! subparser.skip(s, o)) {
            o.reset();
            return false;
        }
        o.parsed();
        return true;
    }
}

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
