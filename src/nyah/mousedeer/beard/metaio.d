module beard.metaio;

import beard.io;
import std.stdio;
import std.typecons : Tuple;
import std.string : indexOf;

void printType(T, S)(S stream, int indent = 0) {
    static if (is(T U : U[])) {
        printType!U(stream, indent);
        stream.write("[]");
    }
    else static if (__traits(hasMember, T, "printType")) {
        T.printType(stream, indent);
    }
    else static if (is(T U : P!A, alias P, A...)) {
        static if (A.length) {
            string name = typeid(U).name;
            stream.write(name[0 .. indexOf(name, "!")], " {\n");

            void printArg(int idx, S)(S stream, int indent) {
                printIndent(stream, indent + 1);
                printType!(A[idx])(stream, indent + 1);
                // stream.write(typeid(A[idx]));

                static if (idx < A.length - 1) {
                    stream.write(",\n");
                    printArg!(idx + 1)(stream, indent);
                }
            }
            printArg!(0)(stream, indent);

            stream.write("\n");
            printIndent(stream, indent);
            stream.write("}");
        }
        else stream.write(typeid(U));
    }
    else
        stream.write(typeid(T));
}

void printType(T)(int indent = 0) {
    printType!T(stdout, indent);
}
