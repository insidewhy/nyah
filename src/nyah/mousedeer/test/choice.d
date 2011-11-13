module mousedeer.test.choice;

import mousedeer.test.common;

struct Id {
    mixin makeNode!(ManyPlus!(CharNotFrom!"\n\t "));
}

struct Stars {
    mixin makeNode!(ManyPlus!(CharFrom!"+*"));
}

struct Integer {
    mixin makeNode!(ManyPlus!(CharRange!"09"));
}

int main() {
    auto s = new Stream!Whitespace;

    alias Lexeme!(
        Choice!(Char!"_",
                CharRange!"azAZ"),
        Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

    // collapsing variants together
    s.set("C hey ***+ 123");
    parseTest!(ManyPlus!(Choice!(
        Choice!(Stars, CharRange!"CD"),
        Choice!(Integer, Identifier),
    )))("choice 3", s);

    // parseTest!(Id)("node 1", s);
    s.set("kitten friend yeah");
    parseTest!(ManyPlus!Id)("node 1", s);

    alias ManyPlus!(CharRange!"09") Integer1;

    // not good enough yet
    alias Integer1 Expression1;

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

    return nFailures;
}

