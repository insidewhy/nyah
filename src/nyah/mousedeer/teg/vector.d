module teg.vector;

template Vector(T) {
    alias T[] Vector;
}

auto ref push_back(T, U)(ref T[] t, U u) {
    ++t.length;
    t[t.length - 1] = u;
    return t;
}
