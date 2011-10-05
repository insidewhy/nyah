module teg.empty_string;

class EmptyString {
    static bool skip(S)(S s) { return true; }
    static bool skip(S, O)(S s, ref const O o) { return true; }
}
