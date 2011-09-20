module mousedeer.test;

import mousedeer.tuple;
import mousedeer.io;
import mousedeer.vector;

void test() {
    auto t1 = make_tuple(1, "congo", false);
    get!(1)(t1) = "sando";

    println(t1, "baby");
    println(make_tuple("congo"), "baby");

    vector!(int) v;
    v.push_back(2).push_back(3);
    println(v);
}

import teg.all;

void testParser() {
    alias many_range!(char_from!"\n\t ") whitespace;
    auto s = new stream!(whitespace)("baby kitten friend");

    alias sequence!(char_!"baby", char_!"kitten") seq;

    println(seq.skip(s));
    println(s.front());
    s.skip_whitespace();
    println(s.front());
}
