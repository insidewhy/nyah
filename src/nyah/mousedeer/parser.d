module mousedeer.parser;

import mousedeer.tuple;
import mousedeer.io;
import mousedeer.vector;

void test() {
    auto t1 = make_tuple(1, "congo", false);
    get!(1)(t1) = "sando";

    println(t1, "baby");
    println(make_tuple("congo"), "baby");

    int[] v;
    v.push_back(2).push_back(3);
    println(v);
}
