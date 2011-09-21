module beard.io;

import std.stdio;
import std.typecons;

immutable INDENT_STR = "    ";

private void print_indent(S)(S stream, int indent) {
    for (int i = 0; i < indent; ++i) stream.write(INDENT_STR);
}

private void _print(S, H)(S stream, int indent, H h) {
    static if (isTuple!(H)) {
        stream.write("(\n");
        print_indent(stream, indent + 1);
        print_indented(stream, indent + 1, h[0]);
        foreach(value; h[1..$]) {
            stream.write(",\n");
            print_indent(stream, indent + 1);
            print_indented(stream, indent + 1, value);
        }
        stream.writeln();
        print_indent(stream, indent);
        stream.write(')');
    }
    else static if (is(H : string)) {
        stream.write(h);
    }
    else static if (std.traits.isArray!(H)) {
        stream.write("[\n");
        print_indent(stream, indent + 1);
        print_indented(stream, indent + 1, h[0]);
        foreach(value; h[1..$]) {
            stream.write(",\n");
            print_indent(stream, indent + 1);
            print_indented(stream, indent + 1, value);
        }

        stream.writeln();
        print_indent(stream, indent);
        stream.write(']');
    }
    else stream.write(h);
}

private void print_tail(S, H, T...)(S stream, int indent, H h, T t) {
    stream.write(' ');
    _print(stream, indent, h);
    print_tail(stream, indent, t);
}

private void print_tail(S)(S stream, int indent) {}

void print_indented(S, H, T...)(S stream, int indent, H h, T t) {
    _print(stream, indent, h);
    print_tail(stream, indent, t);
}

void print_indented(H...)(int indent, H h) {
    print_indented(stdout, h);
}

// todo: check if first argument is stream or not
void print(T...)(T t) {
    print_indented(stdout, 0, t);
}

void println(T...)(T t) {
    print(t);
    writeln();
}
