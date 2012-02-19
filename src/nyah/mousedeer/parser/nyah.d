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
class TypeParameter {
    mixin makeNode!(Choice!(
        Lexeme!(
            StoreChar!(Char!":"), NonBreakingSpace, Type),
        Type
    ));
}

alias JoinedPlusTight!(
    NonBreakingSpace,
    Choice!(
        Sequence!(Char!"[", Joined!(Char!",", Node!TypeParameter), Char!"]"),
        Lexeme!(StoreRange!(Choice!(Char!"?", Char!"...")),
                NonBreakingSpace,
                Optional!Identifier),
        Identifier))  Type;

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
alias Sequence!(Identifier, Optional!TypeParameter) ArgumentDefinition;

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

class ReturningOp {
    mixin makeNode!(
        TreeOptional!(Choice!(Char!"=", Char!"return")), AssigningOp);
}

// right to left
class AssigningOp { mixin makeNode!(BinOp!(AssigningOps, TupleOp)); }

class TupleOp { mixin makeNode!(BinOp!(Char!",", OrOp)); }

class OrOp { mixin makeNode!(BinOp!(Char!"||", AndOp)); }

class AndOp { mixin makeNode!(BinOp!(Char!"&&", BitwiseOrOp)); }

class BitwiseOrOp { mixin makeNode!(BinOp!(Char!"|", BitwiseXOrOp)); }

class BitwiseXOrOp { mixin makeNode!(BinOp!(Char!"^", BitwiseAndOp)); }

class BitwiseAndOp { mixin makeNode!(BinOp!(Char!"&", EquivalenceOp)); }

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
            Lexeme!(StoreChar!(Char!"+"), Not!(Char!"+")),
            Lexeme!(StoreChar!(Char!"&"), Not!(Char!"&"))
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
        CharFrom!":?",
        NonBreakingSpace,
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
