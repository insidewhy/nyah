module mousedeer.test.nyah;

import mousedeer.parser.nyah;
import mousedeer.test.common;

int main() {
    auto s = new Stream!Whitespace(`
def hey {
    hello *= 12
}

def add(a, b) {
    hello
}
`);
    parseTest!Grammar("nyah", s);
    return nFailures;
}
