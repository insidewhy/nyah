module teg.char_;

import teg.store;

class Char(string T) {
    enum length = T.length;

    static if (length > 1)
        alias StoreRange!Char SkippedParser;
    else
        alias StoreChar!Char SkippedParser;

    static bool match(S)(S s) {
        if (s.length < T.length) return false;

        for (auto i = 0u; i < T.length; ++i)
            if (s[i] != T[i]) return false;

        return true;
    }

    static bool skip(S)(S s) {
        if (match(s)) {
            s.advance(T.length);
            return true;
        }
        else return false;
    }
}
