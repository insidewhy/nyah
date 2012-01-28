module teg.detail.match_one_char;

public import teg.detail.parser : storingParser;

template storeOneChar() {
    mixin storingParser;

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

    alias char value_type;
}
