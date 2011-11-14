module mousedeer.test.nyah;

import mousedeer.parser.nyah;
import mousedeer.test.common;

int main() {
    auto s = new Stream!Whitespace(`
def hey {
    hello *= 12.1 + b * a && c
}

def add(a, b) {
    a + b
}
`);
    parseTest!Grammar("nyah", s);
    return nFailures;
}
