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


void testParser() {
    alias many_range!(char_from!"\n\t ") whitespace;
    auto s = new stream!whitespace("baby kitten friend");

    alias sequence!(char_!"baby", char_!"kitten") seq;

    println(seq.skip(s));
    println(s.front());
    s.skip_whitespace();
    println(s.front());

    s.reset();
    alias many_range!(char_not_from!" ") word;
    auto store_word = new word();
    if (store_word.parse(s))
        writefln("stored '%s'", store_word.value_);
    else
        println("failed to store word");
}
