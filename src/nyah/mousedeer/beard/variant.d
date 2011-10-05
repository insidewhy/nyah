module beard.variant;

import beard.meta;
import beard.io;
import std.c.string : memcpy;
import std.typetuple : staticIndexOf;
import std.traits : Unqual;

private template maxSize(size_t _size) {
    enum size = _size;
    template add(U) {
        alias maxSize!(_size > U.sizeof ? _size : U.sizeof) add;
    }
}

// may store any of T or be empty.
// I would prefer only allowing empty if void is in T and creating an object
// of the first type when default initialising.
// Unfortunately D does not allow default constructors for structs :(
struct Variant(T...) {
    alias T          types;
    enum size =      foldLeft2!(maxSize!0u, T).size;
    enum n_types =   T.length;

    void opAssign(U)(U rhs) {
        static if (contains!(U, T)) {
            // copying object references like this is okay
            static if (is(T == class) && is(T == shared))
                memcpy(&value_, cast(const(void*)) &rhs, rhs.sizeof);
            else
                memcpy(&value_, &rhs, rhs.sizeof);
            idx_ = staticIndexOf!(U, T);
        }
        else static if (is(U == Variant)) {
            this.value_ = rhs.value_;
            this.idx_ = rhs.idx_;
        }
        else static assert(false, "invalid variant type");
    }

    void printTo(S)(int indent, S stream) {
        struct variantPrint {
            void opCall(T)(T t) { print_indented(stream_, indent_, t); }
            void empty() { print_indented(stream_, indent_, "<empty>"); }

            this(S s, int indent) { stream_ = s; indent_ = indent; }
            S stream_;
            int indent_;
        }

        apply(variantPrint(stream, indent));
    }

    // this calls directly through a compile time constructed vtable.
    auto apply(F)(ref F f) {
        alias typeof(F.opCall(T[0])) return_type;

        static return_type fwd(uint i)(ref Variant t, ref F f) {
            static if (i < T.length)
                return f.opCall(t.as!(T[i])());
            else
                return f.empty();
        }

        static string makeFwd(uint idx)() {
            static if (idx < T.length + 1)
                return (idx ? "," : "[") ~
                        "&fwd!" ~ idx.stringof ~ makeFwd!(idx + 1);
            else
                return "]";
        }

        static return_type function(ref Variant, ref F)[T.length + 1] forwarders =
            mixin(makeFwd!0());

        return forwarders[this.idx_](this, f);
    }

    ref T as(T)() { return * cast(T*) &value_; }

    bool empty() @property const { return idx_ >= T.length; }

    ////////////////////////////////////////////////////////////////////////
    this(U)(U rhs) { this = rhs; }

  private:
    union {
        ubyte[size] value_;
        // mark the region as a pointer to stop objects being garbage collected
        static if (size >= (void*).sizeof)
            void* p[size / (void*).sizeof];
    }

    uint idx_ = T.length;
}

template isVariant(T) {
    // d won't allow enum isVariant = is(...);
    static if (is(Unqual!T Unused : Variant!U, U...))
        enum isVariant = true;
    else
        enum isVariant = false;
}
