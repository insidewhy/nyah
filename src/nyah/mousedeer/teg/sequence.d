module teg.sequence;

class sequence(T...) if (T.length > 1) {
    static bool skip(S)(S s) {
        if (! T[0].skip(s)) return false;

        auto save = s.backup();
        foreach (p; T[1..$]) {
            s.skip_whitespace();

            if (s.empty() || ! p.skip(s)) {
                s.restore(save);
                return false;
            }
        }

        return true;
    }
}

class sequence(T) : T {}
