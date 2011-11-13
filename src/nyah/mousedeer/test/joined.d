module mousedeer.test.joined;

import mousedeer.parser.nyah;
import mousedeer.test.common;

int main() {
    auto s = new Stream!Whitespace("hey-baby - boy");
    parseTest!(JoinedPlusTight!(Char!"-", SimpleId))("joined", s);

    s.set("function add(a, b ,c) { var a1\nvar b1 }\nfunction pump() {}");
    parseTest!(ManyPlus!(
        Char!"function", SimpleId,
        Char!"(", Joined!(Char!",", SimpleId), Char!")",
        Char!"{", Many!SimpleVariable, Char!"}"
    ))("joined 2", s);

    alias Joined!(CharFrom!"*+", SimpleId) JoinStores;

    s.set(`hey * baby + dog`);
    parseTest!JoinStores("join stores", s);

    return nFailures;
}

