module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

class Expression { mixin makeNode!AssigningOp; }
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

//////////////////////////////////////////////////////////////////////////////
// expressions
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
    mixin makeNode!(TreeJoined!(AssigningOps, OrOp));
}

class OrOp {
    mixin makeNode!(TreeJoined!(Char!"||", AndOp));
}

class AndOp {
    mixin makeNode!(TreeJoined!(Char!"&&", BitwiseOrOp));
}

class BitwiseOrOp {
    mixin makeNode!(TreeJoined!(Char!"|", BitwiseXOrOp));
}

class BitwiseXOrOp {
    mixin makeNode!(TreeJoined!(Char!"^", BitwiseAndOp));
}

class BitwiseAndOp {
    mixin makeNode!(TreeJoined!(Char!"&", EquivalenceOp));
}

class EquivalenceOp {
    mixin makeNode!(
        TreeJoined!(Choice!(Char!"==", Char!"!="), InequalityOp));
}

class InequalityOp {
    mixin makeNode!(TreeJoined!(
        Choice!(Char!"<=", Char!">=", Char!"<", Char!">"),
        ShiftOp));
}

class ShiftOp {
    mixin makeNode!(
        TreeJoined!(Choice!(Char!"<<", Char!">>"), AdditionOp));
}

class AdditionOp {
    mixin makeNode!(TreeJoined!(CharFrom!"+-", ScalingOp));
}

class ScalingOp {
    mixin makeNode!(TreeJoined!(CharFrom!"*/%", PointerToMemberOp));
}

class PointerToMemberOp {
    mixin makeNode!(TreeJoined!(Choice!(Char!".*", Char!"->*"), PrefixOp));
}

// class PrefixOp {
//     mixin makeNode!(
//         TreeJoined!(Choice!(
//             Char!".*", Char!"->*"),
//             PrefixOp));
// }

alias Data PrefixOp; // ...

alias Choice!(Identifier, Number) Data;

//////////////////////////////////////////////////////////////////////////////
// top level
alias Function TopLevel; // ...

alias Many!TopLevel Grammar;
