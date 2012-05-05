module mousedeer.identifiable;

import teg.range : Range;

// This has to be a class rather than a interface for the call through
// Variant.base!Identifiable to work.
class Identifiable {
    ref Range id() { assert(false, "pure virtual"); }
}
