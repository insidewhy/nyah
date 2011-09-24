module teg.char_range;

import teg.detail.match_one_char;

// "az09" would match characters through a-z or 0-9
class char_range(string T) {
    mixin store_one_char;

    static bool match(S)(S s) {
        for (auto i = 0u; i < T.length; i += 2)
            if (s.front() >= T[i] && s.front() <= T[i + 1]) return true;

        return false;
    }
}

