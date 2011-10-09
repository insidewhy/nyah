module mousedeer.test.maths;

import mousedeer.test.common;

// Expression breaks the self-referential node chain.
// Such types must be classes and must appear before referencing classes due
// to how the D compiler works.
class Expression {
    mixin makeNode!(Addition);
}

struct Addition {
    mixin makeNode!(JoinedPlus!(Char!"+", Multiplication));
}

struct Multiplication {
    mixin makeNode!(JoinedPlus!(Char!"*", Term));
}

alias ManyPlus!(CharRange!"09") Integer;

alias Choice!(
    Integer,
    Sequence!(Char!"(", Node!Expression, Char!")")) Term;

int main() {
    alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

    auto s = new Stream!Whitespace("3 + 1 * (2 + 3 * 2) * 1");
    // println("bum");
    // println(typeid(Multiplication.value_type));

    parseTest!(ManyPlus!Expression)("node 2", s);

    return nFailures;
}
