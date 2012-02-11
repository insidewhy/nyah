module mousedeer.test.nyah;

import mousedeer.parser.nyah;
import teg.test.common;

int main() {
    auto s = new Stream!Whitespace(`
def hey {
    hello *= 12.1 + b * a && c
}

override def add(a, b) {
    a + b
    c(1, 2)
    x * y + c
    d 4 5

    x++
    ++y

    m.baby(1, 2)
}
`);
    parseTest!Grammar("nyah", s);
    return nFailures;
}
