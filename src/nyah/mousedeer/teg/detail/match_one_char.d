module teg.detail.match_one_char;

template match_one_char() {
    static bool skip(S)(S s) {
        if (match(s)) {
            s.advance();
            return true;
        }
        else return false;
    }
}
