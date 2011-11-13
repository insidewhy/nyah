module mousedeer.test.nyah;

import mousedeer.parser.nyah;
import mousedeer.test.common;

int main() {
    auto s = new Stream!Whitespace(`
def hey {}

def add(a, b) {}
`);
    parseTest!Grammar("nyah", s);
    return nFailures;
}
