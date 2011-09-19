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

import teg.stream;
import teg.char_;

void testParser() {
    auto s = new stream("baby kitten");

    alias char_!("baby") babystr;
    println(babystr.skip(s));
    println(s.front());
}
