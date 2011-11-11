module mousedeer.test.variant;

import mousedeer.test.common;
import beard.variant;
import beard.io;

class S {
    string x, y;

    this(string _x, string _y) { x = _x; y = _y; }

    string toString() {
        return "" ~ x ~ ", " ~ y;
    }
}

int main() {
    alias Variant!(float, int, string, S) var1_t;

    auto def = var1_t();
    println(def);

    auto v1 = var1_t(123);
    println(v1);

    auto v2 = var1_t("booby");
    println(v2);

    auto v3 = var1_t(new S("11!", "2 friend"));
    println(v3);

    v3 = S.init;
    println(v3);

    auto v4 = Variant!(float)();
    println(v4);
    v4 = 1.2f;
    println(v4);

    alias Variant!(float, int, string) src_t;
    alias Variant!(float, int) dest_t;
    auto src = src_t();
    auto dest = dest_t();
    src = 4;
    dest = src;
    println(dest);

    // alias Variant!(void, float, int, string, S) var2_t;
    // var2_t ov1;
    return nFailures;
}
