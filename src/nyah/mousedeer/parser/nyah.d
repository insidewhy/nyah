module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias CharFrom!"\n\t " WhitespaceChars;

alias Choice!(
    Lexeme!(Char!"//", Many!(NotChar!'\n')), // slash slash comments
    // slash star until star slash
    Lexeme!(Char!"/*",
            Many!(Choice!(NotChar!'*',
                          Lexeme!(Char!"*", NotChar!'/'))),
            Char!"*/")
) Comment;

alias ManyPlus!(Choice!(
    WhitespaceChars,
    Comment
)) Whitespace;

alias Skip!(Many!(Choice!(CharFrom!"\t ", Comment))) NonBreakingSpace;

class Expression { mixin makeNode!ReturningOp; }
alias Node!Expression ExpressionRef;

alias Lexeme!(
    Choice!(Char!"_",
            CharRange!"azAZ"),
    Many!(Choice!(CharRange!"azAZ09", Char!"_"))) Identifier;

//////////////////////////////////////////////////////////////////////////////
// numbers
alias ManyPlus!(CharRange!"09") _Integer;
struct Integer { mixin makeNode!_Integer; }
struct RealNumber { mixin makeNode!(_Integer, Char!".", _Integer); }
alias Choice!(RealNumber, Integer) Number;

//////////////////////////////////////////////////////////////////////////////
// strings
struct String {
    mixin makeNode!(Lexeme!(
        Char!"\"",
        Many!(Choice!(
            Lexeme!(Char!"\\", AnyChar),
            NotChar!'\"')),
        Char!"\""));
}

struct Character {
    mixin makeNode!(Lexeme!(
        Char!"'",
        Choice!(
            Lexeme!(StoreChar!(Char!"\\"), AnyChar),
            NotChar!'\"'),
        Char!"'"));
}

// todo interpolated strings, more string escape codes etc.

//////////////////////////////////////////////////////////////////////////////
// types
alias Choice!(
    Lexeme!(
        StoreRange!(Choice!(Char!"?", Char!"...")),
        EmptyString, // to split lexeme storage type
        Optional!Identifier),
    Lexeme!(
        // range rather than char so this stores the same as above
        StoreRange!(Char!":"),
        NonBreakingSpace,
        Identifier),
    Sequence!(Char!"[", Joined!(Char!",", Node!Type), Char!"]"),
    Identifier) TypeElement;

class Type {
    mixin makeNode!(
        Choice!(
            Lexeme!(TypeElement, NonBreakingSpace, Node!Type),
            TypeElement));
}

//////////////////////////////////////////////////////////////////////////////
// meta
// todo

//////////////////////////////////////////////////////////////////////////////
// function
alias Choice!(
    Char!"def!",
    Char!"def",
    Sequence!(Store!(Char!"override"), Char!"def")) FunctionPrefix;

// todo, default arguments, "...", ptr/reference
alias Sequence!(Identifier, Optional!Type) ArgumentDefinition;

alias Sequence!(
    Char!"(",
    Joined!(Char!",", ArgumentDefinition),
    Char!")")                               ArgumentsDefinition;

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
    Sequence!(
        Char!"{",
        // stop two expressions being on same line without a joining semicolon
        JoinedTight!(
            Skip!(ManyPlus!(
                Lexeme!(NonBreakingSpace, CharFrom!("\n;"), NonBreakingSpace))),
            Choice!(Node!Function, Node!VariableDefinition, ExpressionRef)),
        Char!"}"),
    ExpressionRef)     CodeBlock;

template BinOp(J, T...) {
    alias TreeJoinedTight!(
        Lexeme!(NonBreakingSpace, J, Skip!(Many!WhitespaceChars)),
        T) BinOp;
}

class ReturningOp {
    mixin makeNode!(
        TreeOptional!(Choice!(Char!"=", Char!"return")), AssigningOp);
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

// right to left
class AssigningOp { mixin makeNode!(BinOp!(AssigningOps, TupleOp)); }

class TupleOp { mixin makeNode!(BinOp!(Char!",", OrOp)); }

class OrOp { mixin makeNode!(BinOp!(Char!"||", AndOp)); }

class AndOp { mixin makeNode!(BinOp!(Char!"&&", BitwiseOrOp)); }

class BitwiseOrOp { mixin makeNode!(BinOp!(Char!"|", BitwiseXOrOp)); }

class BitwiseXOrOp { mixin makeNode!(BinOp!(Char!"^", BitwiseAndOp)); }

class BitwiseAndOp {
    mixin makeNode!(
        BinOp!(Lexeme!(StoreChar!(Char!"&"), Not!(Char!"&")), EquivalenceOp));
}

class EquivalenceOp {
    mixin makeNode!(
        BinOp!(Choice!(Char!"==", Char!"!="), InequalityOp));
}

class InequalityOp {
    mixin makeNode!(BinOp!(
        Choice!(Char!"<=", Char!">=", Char!"<", Char!">"), ShiftOp));
}

class ShiftOp {
    mixin makeNode!(BinOp!(Choice!(Char!"<<", Char!">>"), AdditionOp));
}

class AdditionOp { mixin makeNode!(BinOp!(CharFrom!"+-", ScalingOp)); }

class ScalingOp { mixin makeNode!(BinOp!(CharFrom!"*/%", PointerToMemberOp)); }

class PointerToMemberOp {
    mixin makeNode!(BinOp!(Choice!(Char!".*", Char!"->*"), PrefixOp));
}

class PrefixOp {
    mixin makeNode!(
        TreeOptional!(Choice!(
            Char!"++",
            Char!"--",
            Char!"-",
            Char!"*",
            Char!"+",
            Char!"&"
        )),
        Choice!(SuffixOp, MemberCallOp, FunctionCall));
}

class SuffixOp {
    mixin makeNode!(
        Lexeme!(Term, NonBreakingSpace, Choice!(Char!"++", Char!"--")));
}

class MemberCallOp {
    mixin makeNode!(Lexeme!(Term,
                            NonBreakingSpace,
                            Choice!(Char!"->", Char!".")),
                    JoinedTight!(NonBreakingSpace, Term));
}

class FunctionCall {
    mixin makeNode!(TreeJoinedTight!(NonBreakingSpace, Term));
}

alias Choice!(
    Identifier,
    Number,
    String,
    Character,
    Sequence!(Char!"(", ExpressionRef, Char!")")) Term;

class VariableDefinition {
    mixin makeNode!(Lexeme!(
        Identifier,
        NonBreakingSpace,
        Try!(Lexeme!(CharFrom!":?")),
        Type,
        Optional!(
            Lexeme!(NonBreakingSpace, Char!"="),
            ExpressionRef)));
}

//////////////////////////////////////////////////////////////////////////////
// classes

//////////////////////////////////////////////////////////////////////////////
// top level
alias Choice!(Function, VariableDefinition) TopLevel; // todo class etc.

alias Many!TopLevel Grammar;
