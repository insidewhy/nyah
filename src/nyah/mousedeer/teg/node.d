module teg.node;

import teg.detail.parser : hasSubparser, storingParser;
import beard.io;

template node(P...) {
    alias void __IsNode;

    mixin hasSubparser!P;
    mixin storingParser;

    static bool skip(S, O)(S s, ref O o) {
        return subparser.skip(s, o.value_);
    }

    void printTo(S)(int indent, S stream) {
        // print_indented(stream, indent, typeid(this).stringof);
        print_indented(stream, indent, typeid(this).name, "{\n");
        print_indent(stream, indent + 1);
        print_indented(stream, indent + 1, value_, '\n');
        print_indent(stream, indent);
        print('}');
    }

    stores!subparser value_;
}

template isNode(T) {
    enum isNode = is(T.__IsNode);
}
