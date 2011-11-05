module mousedeer.test.maths;

import mousedeer.test.common;

// BasicExpression breaks the self-referential node chain.
// Such types must be classes and must appear before referencing classes due
// to how the D compiler works.
class BasicExpression {
    mixin makeNode!BasicAddition;
}

struct BasicAddition {
    // mixin makeNode!(JoinedPlus!(Char!"+", BasicMultiplication));
    mixin makeNode!(TreeJoined!(Char!"+", BasicMultiplication));
}

struct BasicMultiplication {
    mixin makeNode!(JoinedPlus!(Char!"*", BasicTerm));
}

alias ManyPlus!(CharRange!"09") Integer;

alias Choice!(
    Integer,
    Sequence!(Char!"(", Node!BasicExpression, Char!")")) BasicTerm;

int main() {
    alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

    auto s = new Stream!Whitespace("3 + 1 * (2 + 3 * 2) * 1");

    parseTest!(ManyPlus!BasicExpression)("node 2", s);

    return nFailures;
}
