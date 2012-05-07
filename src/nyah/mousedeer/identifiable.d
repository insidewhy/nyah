module mousedeer.identifiable;

import teg.range : Range;

// This has to be a class rather than a interface for the call through
// Variant.base!Identifiable to work.
abstract class Identifiable {
  ref Range id() { assert(false, "pure virtual"); }
}
// vim:ts=2 sw=2:
