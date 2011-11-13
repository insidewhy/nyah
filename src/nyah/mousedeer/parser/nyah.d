module mousedeer.parser.nyah;

import teg.all;

//////////////////////////////////////////////////////////////////////////////
// global
alias ManyPlus!(CharFrom!"\n\t ") Whitespace;

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

// improve:
alias Identifier ArgumentDefinition;

alias Sequence!(
    Char!"(",
    Joined!(Char!",", ArgumentDefinition),
    Char!")")                               ArgumentsDefinition;

alias Sequence!(Char!"{", Char!"}")  FunctionBody;

class Function {
    mixin makeNode!(
        FunctionPrefix,
        Identifier,
        Optional!ArgumentsDefinition,
        FunctionBody);
}

//////////////////////////////////////////////////////////////////////////////
// putting it together
alias Function TopLevel;

alias Many!TopLevel Grammar;
