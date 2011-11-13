module mousedeer.test.basic;

import mousedeer.test.common;

int main() {
    auto s = new Stream!Whitespace("var friend = baby");

    alias CharNotFrom!"\n\t " NonWhitespace;
    alias ManyPlus!NonWhitespace Word;
    alias Sequence!(Char!"var", Word) Vardef;

    parseTest!(Vardef)("sequence", s);

    parseTest!(
        Sequence!(Char!"var", Word, Char!"=", Word))("sequence2", s);

    s.set("var v1\nvar v2");
    parseTest!(Many!Vardef)("many list", s);

    parseTest!(ManyPlus!SimpleVariable)("lexeme", s);

    parseTest!(Store!(SimpleVariable))("store range", s);

    return nFailures;
}
