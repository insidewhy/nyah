module mousedeer.test;

import teg.all;
import beard.io;
import beard.variant;
import std.stdio;

auto nFailures = 0u;

void parseTest(P, S)(string name, S s) {
    s.reset();
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
    alias many!(char_from!"\n\t ") whitespace;

    auto s = new stream!whitespace("var friend = baby");

    alias char_not_from!"\n\t " non_whitespace;
    alias many_plus!non_whitespace word1;
    alias sequence!(char_!"var", word1) vardef1;

    parseTest!(vardef1)("sequence", s);

    parseTest!(
        sequence!(char_!"var", word1, char_!"=", word1))("sequence2", s);

    s.set("var v1\nvar v2");
    parseTest!(many!vardef1)("many list", s);

    alias lexeme!(char_range!"azAZ", many!(char_range!"azAZ09")) identifier1;

    alias sequence!(char_!"var", identifier1) variable1;
    parseTest!(many_plus!variable1)("lexeme", s);

    parseTest!(store_range!(variable1))("store range", s);

    s.set("hey-baby - boy");
    parseTest!(joined_plus_tight!(char_!"-", identifier1))("joined", s);

    s.set("function add(a, b ,c) { var a1\nvar b1 }\nfunction pump() {}");
    parseTest!(many_plus!(
        char_!"function", identifier1,
        char_!"(", joined!(char_!",", identifier1), char_!")",
        char_!"{", many!variable1, char_!"}"
    ))("joined 2", s);

}

class S {
    string x, y;

    this(string _x, string _y) { x = _x; y = _y; }

    string toString() {
        return "" ~ x ~ ", " ~ y;
    }
}

void testVariant() {
    alias variant!(float, int, string, S) var1_t;
    auto v1 = var1_t(123);
    auto v2 = var1_t("booby");
    auto v3 = var1_t(new S("11!", "2 friend"));
    v1.printTo(0, stdout);
    println(v1);
    println(v2);
    println(v3);
}

int main() {
    // testParser();
    testVariant();
    return nFailures;
}
