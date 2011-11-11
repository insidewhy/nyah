module mousedeer.test.maths;

import mousedeer.test.common;

alias ManyPlus!(CharRange!"09") Integer;

// BasicExpression breaks the self-referential node chain.
// Such types must be classes and must appear before referencing classes due
// to how the D compiler works.
class BasicExpression { mixin makeNode!BasicAddition; }
struct BasicAddition {
    mixin makeNode!(JoinedPlus!(Char!"+", BasicMultiplication));
}
struct BasicMultiplication {
    mixin makeNode!(JoinedPlus!(Char!"*", BasicTerm));
}
alias Choice!(
    Integer, Sequence!(Char!"(", Node!BasicExpression, Char!")")) BasicTerm;

class Expression { mixin makeNode!Addition; }
// Tree* parsers must be class rather than struct
class Addition { mixin makeNode!(TreeJoined!(Char!"+", Multiplication)); }
class Multiplication { mixin makeNode!(TreeJoined!(Char!"*", Term)); }
alias Choice!(
    Integer, Sequence!(Char!"(", Node!Expression, Char!")")) Term;

int main() {
    alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

    auto s = new Stream!Whitespace("3 + 1 * (2 + 3 * 2) * (1)");

    parseTest!(ManyPlus!BasicExpression)("basic maths", s);
    parseTest!(ManyPlus!Expression)("maths", s);

    return nFailures;
}
