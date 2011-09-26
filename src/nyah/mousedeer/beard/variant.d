module beard.variant;

import beard.meta;
import beard.io;
import std.stdio : writeln;
import std.c.string : memcpy;

private template maxSize(size_t _size) {
    enum size = _size;
    template add(U) {
        alias maxSize!(_size > U.sizeof ? _size : U.sizeof) add;
    }
}

private struct VariantApplier(T, F) {
    alias typeof(F.opCall(T.types[0])) return_type;
    static return_type function(T, F)[T.types.length] forwarders;

    template createFwd(uint i) {
        static void run() {
            static if (i < T.types.length) {
                // todo: create forwarder here
                // writeln(i);
                createFwd!(i + 1).run();
            }
        }
    }

    static auto make() {
        VariantApplier ret;
        createFwd!0u.run();
        return ret;
    }

    return_type run(ref T t, F f) {
        createFwd!0u.run();
    }
}

// forward to a struct to give the mixin a scope to inject the static members
// into
auto variant_apply(T, F)(ref T t, F f) {
    static auto applier = VariantApplier!(T, F).make();
    return applier.run(t, f);
}

// may store any of T, or empty also if void is in T
struct variant(T...) {
    alias T          types;
    enum size =      foldLeft2!(maxSize!0u, T).size;
    enum n_types =   T.length;

    void opAssign(U)(U rhs) {
        static if (contains!(U, T)) {
            static if (is(T == class) && is(T == shared))
                memcpy(&value_, cast(const(void*)) &rhs, rhs.sizeof);
            else
                memcpy(&value_, &rhs, rhs.sizeof);
        }
        else static if (is(U == variant)) {
            this.value_ = rhs.value_;
            this.idx_ = rhs.idx_;
        }
        else static assert(false, "invalid variant type");
    }

    void printTo(S)(int indent, S stream) {
        variant_apply(this, variantPrint!(S)(indent, stream));
        stream.write("variant");
    }

    T as(T)() {
        return * cast(T*) &value_;
    }

    ////////////////////////////////////////////////////////////////////////
    this(U)(U rhs) {
        this = rhs;
    }

    union {
        ubyte[size] value_;
        // mark the region as a point to stop objects being garbage collected
        static if (size >= (void*).sizeof)
            void* p[size / (void*).sizeof];
    }

    uint idx_ = 0;
}

private struct variantPrint(S) {
    void opCall(T)(T t) { print(stream_, indent_, t); }

    this(int indent, S s) { indent_ = indent; stream_ = s; }
    S stream_;
    int indent_;
}
