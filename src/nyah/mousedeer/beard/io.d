module beard.io;

import beard.termcolor;
import std.stdio;
import std.typecons;

immutable INDENT_STR = "    ";

void printIndent(S)(S stream, int indent) {
    for (int i = 0; i < indent; ++i) stream.write(INDENT_STR);
}

private void _print(S, H)(S stream, int indent, H h) {
    static if (isTuple!H) {
        stream.write("(\n");
        printIndent(stream, indent + 1);
        printIndented(stream, indent + 1, h[0]);
        foreach(value; h[1..$]) {
            stream.write(",\n");
            printIndent(stream, indent + 1);
            printIndented(stream, indent + 1, value);
        }
        stream.writeln();
        printIndent(stream, indent);
        stream.write(')');
    }
    else static if (is(H : string)) {
        stream.write(h);
    }
    else static if (std.traits.isArray!(H)) {
        if (! h.length) {
            stream.write("[]");
            return;
        }

        stream.write("[\n");
        printIndent(stream, indent + 1);
        printIndented(stream, indent + 1, h[0]);
        foreach(value; h[1..$]) {
            stream.write(",\n");
            printIndent(stream, indent + 1);
            printIndented(stream, indent + 1, value);
        }

        stream.writeln();
        printIndent(stream, indent);
        stream.write(']');
    }
    else static if (__traits(hasMember, H, "printTo")) {
        // better than compiles check in case user messes up a templated
        // printTo and then wonders why it isn't called
        h.printTo(indent, stream);
    }
    else stream.write(h);
}

private void printTail(S, H, T...)(S stream, int indent, H h, T t) {
    stream.write(' ');
    _print(stream, indent, h);
    printTail(stream, indent, t);
}

private void printTail(S)(S stream, int indent) {}

void printIndented(S, H, T...)(S stream, int indent, H h, T t) {
    _print(stream, indent, h);
    printTail(stream, indent, t);
}

void printIndented(H...)(int indent, H h) {
    printIndented(stdout, h);
}

// todo: check if first argument is stream or not
void print(T...)(T t) {
    printIndented(stdout, 0, t);
}

void println(T...)(T t) {
    print(t);
    writeln();
}
