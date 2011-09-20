module teg.many;

import teg.detail.parser;

class many_range(T...) : parser!T {
    static bool skip(S)(S s) {
        while (subparser.skip(s)) {
            if (s.empty()) break;
        };
        return true;
    }
}

class many_list(T...) : parser!T {
}

class many(T...) {
}
