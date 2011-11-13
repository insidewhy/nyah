module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

class Expression { mixin makeNode!AssigningOperator; }
alias Node!Expression ExpressionRef;

//////////////////////////////////////////////////////////////////////////////
// number
alias ManyPlus!(CharRange!"09") Integer;
alias Sequence!(Integer, Char!".", Integer) RealNumber;
alias Choice!(Integer, RealNumber) Number;

alias Lexeme!(
    Choice!(Char!"_",
            CharRange!"azAZ"),
    Many!(Choice!(CharRange!"azAZ09", Char!"_")))     Identifier;

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
    ExpressionRef)     FunctionBody;

class Function {
    mixin makeNode!(
        FunctionPrefix,
        Identifier,
        Optional!ArgumentsDefinition,
        FunctionBody);
}

//////////////////////////////////////////////////////////////////////////////
// expressions
alias Choice!(
    Char!"+=",
    Char!"-=",
    Char!"*=",
    Char!"/=",
    Char!"%=",
    Char!"<<=",
    Char!">>=",
    Char!"&=",
    Char!"^=",
    Char!"|=") AssigningOperators;

class AssigningOperator {
    mixin makeNode!(TreeJoined!(AssigningOperators, OrOperator));
}

alias Identifier OrOperator; // ...

//////////////////////////////////////////////////////////////////////////////
// top level
alias Function TopLevel; // ...

alias Many!TopLevel Grammar;
