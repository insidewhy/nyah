module mousedeer.test.maths;

import mousedeer.test.common;

// ordering of rules is important to D compiler, each class must come before
// the one that references it, with the Node! reference last.
// The Node! reference must be a class rather than a struct.
class Addition {
    mixin makeNode!(JoinedPlus!(Char!"+", Multiplication));
}

struct Multiplication {
    mixin makeNode!(JoinedPlus!(Char!"*", Term));
}

alias ManyPlus!(CharRange!"09") Integer;

// alias Integer Term;
alias Choice!(
    Integer,
    Sequence!(Char!"(", Node!Expression, Char!")")) Term;

alias Addition Expression; // ...

int main() {
    alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

    auto s = new Stream!Whitespace("3 + 1 * (2 + 3 * 2) * 1");
    parseTest!(ManyPlus!Expression)("node 2", s);

    return nFailures;
}
