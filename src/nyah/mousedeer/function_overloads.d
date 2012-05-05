module mousedeer.function_overloads;

import mousedeer.identifiable : Identifiable;
import teg.range : Range;

// Represent overloaded functions with the same name.
class FunctionOverloads : Identifiable {
    this(Range id) { id_ = id; }

    ref Range id() { return id_; }

    Range id_;
}
