module teg.joined;

import teg.vector;
import teg.range;
import teg.detail.parser;
import teg.stores;

import beard.io : printIndent, printIndented;

struct Split(T, J) {
    // the split data
    Vector!T  split;

    // the data joined between each piece of split data
    Vector!J  join;

    void printTo(S)(int indent, S stream) {
        immutable name = typeid(this).name;
        if (! split.length) {
            stream.write("joined []");
            return;
        }

        stream.write("joined [\n");
        printIndent(stream, indent + 1);
        printIndented(stream, indent + 1, split[0]);
        for (auto i = 1; i < split.length; ++i) {
            stream.write("\n");
            printIndent(stream, indent + 1);
            printIndented(stream, indent + 1, join[i - 1]);

            stream.write("\n");
            printIndent(stream, indent + 1);
            printIndented(stream, indent + 1, split[i]);
        }

        stream.writeln();
        printIndent(stream, indent);
        stream.write(']');
    }
}

// this version of joined accepts SkipWs/AtLeastOne as the first two arguments
// and is used internally by all of the named versions
class Joined(bool SkipWs, bool AtLeastOne, J, T...) {
    mixin parser!T;

    private alias storesSomething!J JoinStores;

    static if (JoinStores) {
        alias Split!(stores!subparser, stores!J) value_type;

        static ref getSplit(O)(ref O o) { return o.split; }
    }
    else {
        alias Vector!(stores!subparser) value_type;
        static ref getSplit(O)(ref O o) { return o; }
    }

    static bool skip(S)(S s) {
        if (! subparser.skip(s)) return ! AtLeastOne;

        for (;;) {
            skip_whitespace(s);
            if (s.empty()) return true;

            auto save = s.save();
            if (! J.skip(s)) return true;
            skip_whitespace(s);
            if (s.empty() || ! subparser.skip(s)) {
                s.restore(save);
                return true;
            }
        }
    }

    static bool skipTail(S, O)(S s, ref O o) {
        for (;;) {
            skip_whitespace(s);
            if (s.empty()) return true;

            auto save = s.save();

            static if (JoinStores) {
                stores!J value;
                if (! J.parse(s, value)) return true;
                o.join.push_back(value);
            }
            else
                if (! J.skip(s)) return true;

            skip_whitespace(s);
            if (s.empty() || ! _skip(s, o)) {
                s.restore(save);
                return true;
            }
        };
    }

    static bool skip(S, O)(S s, ref O o) {
        if (! _skip(s, o)) return ! AtLeastOne;
        return skipTail(s, o);
    }

    private static bool _skip(S, O)(S s, ref O o) {
        stores!subparser value;
        if (! subparser.parse(s, value)) return false;
        getSplit(o).push_back(value);

        return true;
    }
}

class Joined(J, T...)  : Joined!(true, false, J, T) {}
// at least one T must be matched
class JoinedPlus(J, T...)  : Joined!(true, true, J, T) {}

// tight versions do not allow whitespace around join strings
class JoinedTight(J, T...) : Joined!(false, false, J, T) {}
class JoinedPlusTight(J, T...) : Joined!(false, true, J, T) {}
