module mousedeer.test.basic;

import mousedeer.test.common;
import teg.all;
import beard.io;
import beard.meta;

struct Id {
    mixin node!(ManyPlus!(CharNotFrom!"\n\t "));
}

int main() {
    alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

    auto s = new Stream!Whitespace("var friend = baby");

    alias CharNotFrom!"\n\t " NonWhitespace;
    alias ManyPlus!NonWhitespace Word;
    alias Sequence!(Char!"var", Word) Vardef;

    parseTest!(Vardef)("sequence", s);

    parseTest!(
        Sequence!(Char!"var", Word, Char!"=", Word))("sequence2", s);

    s.set("var v1\nvar v2");
    parseTest!(Many!Vardef)("many list", s);

    alias Lexeme!(CharRange!"azAZ", Many!(CharRange!"azAZ09")) Identifier1;

    alias Sequence!(Char!"var", Identifier1) Variable1;
    parseTest!(ManyPlus!Variable1)("lexeme", s);

    parseTest!(Store!(Variable1))("store range", s);

    s.set("hey-baby - boy");
    parseTest!(JoinedPlusTight!(Char!"-", Identifier1))("joined", s);

    s.set("function add(a, b ,c) { var a1\nvar b1 }\nfunction pump() {}");
    parseTest!(ManyPlus!(
        Char!"function", Identifier1,
        Char!"(", Joined!(Char!",", Identifier1), Char!")",
        Char!"{", Many!Variable1, Char!"}"
    ))("joined 2", s);

    // ////////////////////////////////////////////////////////////////////////////
    // // here begin more useful definitions
    alias Lexeme!(
        Choice!(Char!"_",
                CharRange!"azAZ"),
        Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

    alias ManyPlus!(CharRange!"09") Number;

    // not good enough yet
    alias Number Expression1;

    alias Sequence!(Char!"var", Identifier,
                    Optional!(Char!"=", Expression1)) Variable;

    ///////////////////////////////////////////////////////////////////////////
    s.set(" var outer
            function add(a, b ,c) {
                var a1 = 23
                var b1
            }
            function pump() {
                var _t
            }");

    // Choice forces subparsers to store when possible.
    parseTest!(Choice!(Char!"v", Char!"t"))("choice 1", s);

    alias ManyPlus!(
        Choice!(
            Variable,
            Sequence!(
                Char!"function", Identifier,
                Char!"(", Joined!(Char!",", Identifier), Char!")",
                Char!"{", Many!Variable, Char!"}")))
    JsParser1;

    parseTest!(JsParser1)("choice 2", s);

    // parseTest!(Id)("node 1", s);
    s.set("kitten friend yeah");
    parseTest!(ManyPlus!Id)("node 1", s);

    return nFailures;
}
