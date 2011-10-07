module teg.many;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores : stores, storesChar;

import std.traits : Select;

// this version of many accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class Many(bool SkipWs, bool AtLeastOne, T...) {
    mixin parser!T;

    static if (SkipWs)
        alias Vector!(stores!subparser) value_type;
    else
        alias Range value_type;

    static bool skip(S)(S s) {
        if (AtLeastOne) {
            if (! subparser.skip(s)) return false;
            skip_whitespace(s);
            if (s.empty()) return true;
        }

        while (subparser.skip(s)) {
            skip_whitespace(s);
            if (s.empty()) break;
        };
        return true;
    }

    static bool skip(S, O)(S s, ref O o) {
        static if (! SkipWs) o.parsing(s);

        if (AtLeastOne) {
            if (! _skip(s, o)) {
                static if (! SkipWs) o.clear();
                return false;
            }
            static if (! SkipWs) o.parsed();
            skip_whitespace(s);
            if (s.empty()) return true;
        }

        while (_skip(s, o)) {
            static if (! SkipWs) o.parsed();
            skip_whitespace(s);
            if (s.empty()) break;
        };

        return true;
    }

    private static bool _skip(S, O)(S s, ref O o) {
        static if (SkipWs) {
            stores!subparser value;
            if (! subparser.parse(s, value)) return false;
            o.push_back(value);
        }
        else if (! subparser.skip(s)) return false;

        return true;
    }
}

class ManyRange(T...) : Many!(false, false, T) {}
class ManyList(T...)  : Many!(true, false, T) {}

// ManyPlus parsers return false if the subparser matches zero times.
class ManyPlusRange(T...) : Many!(false, true, T) {}
class ManyPlusList(T...)  : Many!(true, true, T) {}

// ManyRange if subparser stores char, else ManyList
class Many(T...) : Select!(storesChar!T, ManyRange!T, ManyList!T) {}

// ManyPlusRange is subparser stores char, else ManyPlusList
class ManyPlus(T...)
    : Select!(storesChar!T, ManyPlusRange!T, ManyPlusList!T) {}
