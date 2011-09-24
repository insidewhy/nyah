module teg.detail.match_one_char;

import teg.detail.parser : storing_parser;

template match_one_char() {
    static bool skip(S)(S s) {
        if (match(s)) {
            s.advance();
            return true;
        }
        else return false;
    }
}

template store_one_char() {
    mixin storing_parser;

    static bool skip(S)(S s, ref char o) {
        if (match(s)) {
            o = s.front();
            s.advance();
            return true;
        }
        else return false;
    }

    // not good enough apparently: mixin match_one_char;
    static bool skip(S)(S s) {
        if (match(s)) {
            s.advance();
            return true;
        }
        else return false;
    }

    char value_;
}
