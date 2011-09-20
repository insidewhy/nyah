module mousedeer.test;

import mousedeer.tuple;
import mousedeer.io;

import std.stdio;

import teg.all;

void testTupleAndVector() {
    auto t1 = make_tuple(1, "congo", false);
    get!(1)(t1) = "sando";

    println(t1, "baby");
    println(make_tuple("congo"), "baby");

    vector!(int) v;
    v.push_back(2).push_back(3);
    println(v);
}

void parseTest(P, S)(string name, S s) {
    s.reset();
    auto parser = new P();
    write(name, ": ");
    if (parser.parse(s))
        println(parser.value_);
    else
        println("failed to store");
}

void testParser() {
    alias many!(char_from!"\n\t ") whitespace;
    auto s = new stream!whitespace("baby kitten friend");

    alias sequence!(char_!"baby", char_!"kitten") seq;
    println(seq.skip(s));

    alias many_plus!(char_not_from!" ") word;
    parseTest!(word)("word", s);

    alias many_plus!word words;
    parseTest!(words)("words", s);
}
