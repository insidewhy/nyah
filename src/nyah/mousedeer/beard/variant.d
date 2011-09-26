module beard.variant;

import beard.meta;
import beard.io;
import std.stdio : writeln;
import std.c.string : memcpy;
import std.typetuple : staticIndexOf;

private template maxSize(size_t _size) {
    enum size = _size;
    template add(U) {
        alias maxSize!(_size > U.sizeof ? _size : U.sizeof) add;
    }
}

private struct VariantApplier(T, F) {
    alias typeof(F.opCall(T.types[0])) return_type;
    static return_type fwd(uint i)(ref T t, F f) {
        return f.opCall(t.as!(T.types[i])());
    }

    static return_type run(ref T t, F f) {
        return forwarders[t.idx_](t, f);
    }

    static string makeFwd(uint idx)() {
        static if (idx < T.types.length) {
            static if (0 == idx)
                string ret = "[ ";
            else
                string ret = ", ";
            return ret ~ "&fwd!" ~ idx.stringof ~ makeFwd!(idx + 1);
        }
        else return " ]";
    }

    static return_type function(ref T, F)[T.types.length] forwarders =
        mixin(makeFwd!0());
}

// forward to a struct to give the mixin a scope to inject the static members
// into. this calls directly through a compile time constructed vtable.
auto variant_apply(T, F)(ref T t, F f) {
    return VariantApplier!(T, F).run(t, f);
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
            idx_ = staticIndexOf!(U, T);
        }
        else static if (is(U == variant)) {
            this.value_ = rhs.value_;
            this.idx_ = rhs.idx_;
        }
        else static assert(false, "invalid variant type");
    }

    void printTo(S)(int indent, S stream) {
        variant_apply(this, variantPrint!(S)(indent, stream));
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
    void opCall(T)(T t) { print_indented(stream_, indent_, t); }

    this(int indent, S s) { indent_ = indent; stream_ = s; }
    S stream_;
    int indent_;
}
