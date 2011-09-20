module teg.vector;

template vector(T) {
    alias T[] vector;
}

auto ref push_back(T, U)(ref T[] t, U u) {
    ++t.length;
    t[t.length - 1] = u;
    return t;
}
