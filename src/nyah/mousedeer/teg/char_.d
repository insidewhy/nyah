module teg.char_;

import teg.stream;

template char_(string T) {
    static bool match(stream s) {
        if (s.length() < T.length) return false;

        for (auto i = 0u; i < T.length; ++i)
            if (s[i] != T[i]) return false;

        return true;
    }

    static bool skip(stream s) {
        if (match(s)) {
            s.advance(T.length);
            return true;
        }
        else return false;
    }
}
