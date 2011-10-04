module mousedeer.test;

import teg.all;
import beard.io;
import beard.variant;
import std.stdio;

auto nFailures = 0u;

void parseTest(P, S)(string name, S s) {
    s.reset();
    s.skip_whitespace();
    auto parser = new P();
    write(name, ": ");
    if (parser.parse(s))
        println(parser.value_);
    else {
        println("failed to store");
        ++nFailures;
    }
}

void testParser() {
    alias Many!(CharFrom!"\n\t ") Whitespace;

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

    alias Sequence!(Char!"var", Identifier1) variable1;
    parseTest!(ManyPlus!variable1)("lexeme", s);

    parseTest!(StoreRange!(variable1))("store range", s);

    s.set("hey-baby - boy");
    parseTest!(JoinedPlusTight!(Char!"-", Identifier1))("joined", s);

    s.set("function add(a, b ,c) { var a1\nvar b1 }\nfunction pump() {}");
    parseTest!(ManyPlus!(
        Char!"function", Identifier1,
        Char!"(", Joined!(Char!",", Identifier1), Char!")",
        Char!"{", Many!variable1, Char!"}"
    ))("joined 2", s);

    ////////////////////////////////////////////////////////////////////////////
    // here begin more useful definitions
    alias Lexeme!(
        Choice!(Char!"_",
                CharRange!"azAZ"),
        Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

    alias Sequence!(Char!"var", Identifier) Variable;

    ///////////////////////////////////////////////////////////////////////////
    s.set(" var outer
            function add(a, b ,c) {
                var a1
                var b1
            }
            function pump() {
                var _t
            }");

    alias ManyPlus!(
        Choice!(
            Variable,
            Sequence!(
                Char!"function", Identifier,
                Char!"(", Joined!(Char!",", Identifier), Char!")",
                Char!"{", Many!Variable, Char!"}")))
    JsParser1;

    parseTest!(JsParser1)("joined 3", s);
    println(typeid(stores!JsParser1));
}

class S {
    string x, y;

    this(string _x, string _y) { x = _x; y = _y; }

    string toString() {
        return "" ~ x ~ ", " ~ y;
    }
}

void testVariant() {
    alias Variant!(float, int, string, S) var1_t;
    auto def = var1_t();
    auto v1 = var1_t(123);
    auto v2 = var1_t("booby");
    auto v3 = var1_t(new S("11!", "2 friend"));

    println(def);
    println(v1);
    println(v2);
    println(v3);

    // alias Variant!(void, float, int, string, S) var2_t;
    // var2_t ov1;
}

int main() {
    testParser();
    // testVariant();
    return nFailures;
}
