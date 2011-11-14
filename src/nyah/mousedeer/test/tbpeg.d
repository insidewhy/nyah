module mousedeer.test.tbpeg;

import mousedeer.test.common;
import teg.all;
import beard.io;

alias CharFrom!"\n\t " WhitespaceChar;

alias ManyPlus!(Choice!(
    WhitespaceChar,
    Lexeme!(Char!"//", Many!(CharNotFrom!"\n"), Char!"\n"))) Whitespace;

alias Char!"." AnyCharacter;

int main() {
    auto s = new Stream!Whitespace(`
Spacing         <- (\s / "//" ^ (!\n)* ^ \n)+
AnyCharacter    <- '.'
CharacterRange  <= "[" ^ ( [\\] ^ [\\\]sSnNtT] / (. ^ "-" ^ .) / ! "]" )* ^ "]"
Escape          <- [\\] ^ [sSnNtT."'&!+*\\]
String          <= '"' ^ (Escape / ! '"')^* ^ '"' /
                   "'" ^ (Escape / ! "'")^* ^ "'"
Id              <- [a-zA-Z_] ^ [a-zA-Z0-9_]*
ScopedId        <- Id %+ '.'
ScopedRule      <- Id %+ '::'
Primary         <- String / CharacterRange / Escape / AnyCharacter /
                   ScopedRule &! "<" / "(" Expression ")"
Suffix          <= Primary ([?*+] / "^+" / "^*" / "|+" / "|?" )|?
Prefix          <= ( "&!" / "#+" / [&!#] )|? Suffix
Join            <= Prefix ("^%" / "%+" / "%" / "|%" / "|^%") Prefix
Joined          <= (Join / Prefix) |% "^"
Sequence        <= Joined |+
OrderedChoice   <= Sequence |% "/"
Expression      <= OrderedChoice
Rule            < NyuRule = #Id "<" ScopedId % "," [-=] Expression
Grammar         <- Rule+`);

    return nFailures;
}
