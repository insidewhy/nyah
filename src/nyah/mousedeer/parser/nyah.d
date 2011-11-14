module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias CharFrom!"\n\t " WhitespaceChars;
alias CharFrom!"\t " NonBreakingSpace;
alias ManyPlus!WhitespaceChars Whitespace;

class Expression { mixin makeNode!TupleOp; }
alias Node!Expression ExpressionRef;

alias Lexeme!(
    Choice!(Char!"_",
            CharRange!"azAZ"),
    Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

//////////////////////////////////////////////////////////////////////////////
// numbers
alias ManyPlus!(CharRange!"09") _Integer;
struct Integer { mixin makeNode!_Integer; }
struct RealNumber { mixin makeNode!(_Integer, Char!".", _Integer); }
alias Choice!(RealNumber, Integer) Number;

//////////////////////////////////////////////////////////////////////////////
// function
alias Choice!(
    Char!"def",
    Char!"def!",
    Sequence!(Char!"override", Char!"def")) FunctionPrefix;

alias Identifier ArgumentDefinition; // ...

alias Sequence!(
    Char!"(",
    Joined!(Char!",", ArgumentDefinition),
    Char!")")                               ArgumentsDefinition;

alias Choice!(
    Sequence!(
        Char!"{",
        Many!ExpressionRef,
        Char!"}"),
    ExpressionRef)     CodeBlock;

class Function {
    mixin makeNode!(
        FunctionPrefix,
        Identifier,
        Optional!ArgumentsDefinition,
        CodeBlock);
}

template JoinOp(J, T...) {
    alias TreeJoinedTight!(
        Lexeme!(Skip!(Many!NonBreakingSpace), J, Skip!(Many!WhitespaceChars)),
        T) JoinOp;
}

//////////////////////////////////////////////////////////////////////////////
// expressions
class TupleOp {
    mixin makeNode!(JoinOp!(Char!",", AssigningOp));
}

alias Choice!(
    Char!"=",
    Char!"+=",
    Char!"-=",
    Char!"*=",
    Char!"/=",
    Char!"%=",
    Char!"<<=",
    Char!">>=",
    Char!"&=",
    Char!"^=",
    Char!"|=") AssigningOps;

class AssigningOp {
    mixin makeNode!(JoinOp!(AssigningOps, OrOp));
}

class OrOp {
    mixin makeNode!(JoinOp!(Char!"||", AndOp));
}

class AndOp {
    mixin makeNode!(JoinOp!(Char!"&&", BitwiseOrOp));
}

class BitwiseOrOp {
    mixin makeNode!(JoinOp!(Char!"|", BitwiseXOrOp));
}

class BitwiseXOrOp {
    mixin makeNode!(JoinOp!(Char!"^", BitwiseAndOp));
}

class BitwiseAndOp {
    mixin makeNode!(JoinOp!(Char!"&", EquivalenceOp));
}

class EquivalenceOp {
    mixin makeNode!(
        JoinOp!(Choice!(Char!"==", Char!"!="), InequalityOp));
}

class InequalityOp {
    mixin makeNode!(JoinOp!(
        Choice!(Char!"<=", Char!">=", Char!"<", Char!">"),
        ShiftOp));
}

class ShiftOp {
    mixin makeNode!(
        JoinOp!(Choice!(Char!"<<", Char!">>"), AdditionOp));
}

class AdditionOp {
    mixin makeNode!(JoinOp!(CharFrom!"+-", ScalingOp));
}

class ScalingOp {
    mixin makeNode!(JoinOp!(CharFrom!"*/%", PointerToMemberOp));
}

class PointerToMemberOp {
    mixin makeNode!(JoinOp!(Choice!(Char!".*", Char!"->*"), PrefixOp));
}

// class PrefixOp {
//     mixin makeNode!(
//         JoinOp!(Choice!(
//             Char!".*", Char!"->*"),
//             PrefixOp));
// }

alias Term PrefixOp; // ...

alias Choice!(
    Identifier,
    Number,
    Sequence!(Char!"(", ExpressionRef, Char!")")) Term;

//////////////////////////////////////////////////////////////////////////////
// top level
alias Function TopLevel; // ...

alias Many!TopLevel Grammar;
