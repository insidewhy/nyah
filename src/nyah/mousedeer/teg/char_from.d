module teg.char_from;

import std.string : indexOf;
import teg.detail.match_one_char;

class CharFrom(string T) {
    mixin storeOneChar;

    static bool match(S)(S s) {
        return indexOf(T, s.front()) != -1;
    }
}

class CharNotFrom(string T) {
    mixin storeOneChar;

    static bool match(S)(S s) {
        return indexOf(T, s.front()) == -1;
    }
}
