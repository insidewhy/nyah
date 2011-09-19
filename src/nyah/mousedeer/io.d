module mousedeer.io;

import mousedeer.tuple;
import std.stdio;

immutable INDENT_STR = "    ";

private void print_indent(int indent) {
    for (int i = 0; i < indent; ++i) write(INDENT_STR);
}

private void _print(H)(int indent, H h) {
    static if (is(H : is_tuple)) {
        write("(\n");
        print_indent(indent + 1);
        print_indented(indent + 1, h.value[0]);
        foreach(value; h.value[1..$]) {
            write(",\n");
            print_indent(indent + 1);
            print_indented(indent + 1, value);
        }
        writeln();
        print_indent(indent);
        write(')');
    }
    else static if (is(H : string)) {
        write(h);
    }
    else static if (std.traits.isArray!(H)) {
        write("[\n");
        print_indent(indent + 1);
        print_indented(indent + 1, h[0]);
        foreach(value; h[1..$]) {
            write(",\n");
            print_indent(indent + 1);
            print_indented(indent + 1, value);
        }

        writeln();
        print_indent(indent);
        write(']');
    }
    else write(h);
}

private void print_tail(H, T...)(int indent, H h, T t) {
    write(' ');
    _print(indent, h);
    print_tail(indent, t);
}

private void print_tail()(int indent) {}

void print_indented(H, T...)(int indent, H h, T t) {
    _print(indent, h);
    print_tail(indent, t);
}

void print(T...)(T t) {
    print_indented(0, t);
}

void println(T...)(T t) {
    print(t);
    writeln();
}
