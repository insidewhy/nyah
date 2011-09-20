module teg.char_from;

import std.string : indexOf;
import teg.detail.match_one_char;

class char_from(string T) {
    mixin store_one_char;

    static bool match(S)(S s) {
        return indexOf(T, s.front()) != -1;
    }
}

class char_not_from(string T) {
    mixin store_one_char;

    static bool match(S)(S s) {
        return indexOf(T, s.front()) == -1;
    }
}
