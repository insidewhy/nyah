module teg.char_from;

import std.string : indexOf;

class char_from(string T) {
    static bool match(S)(S s) {
        return indexOf(T, s.front()) != -1;
    }

    static bool skip(S)(S s) {
        if (match(s)) {
            s.advance();
            return true;
        }
        else return false;
    }
}

