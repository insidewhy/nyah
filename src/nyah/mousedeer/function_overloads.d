module mousedeer.function_overloads;

import mousedeer.parser.nyah : Function;
import mousedeer.identifiable : Identifiable;
import teg.range : Range;
import beard.vector : pushBack;

// Represent a group of overloaded functions with the same name at the
// same scope.
class FunctionOverloads : Identifiable {
  // construct with any function
  this(Function fun) { addFunction(fun); }

  // cache in functions list, the tree is built later by buildLookupTree.
  void addFunction(Function fun) { pushBack(functions, fun); }

  // build lookup tree. Call after all types are known.
  void buildLookupTree() {
    // TODO:
  }

  ref Range id() { return functions[0].id; }

  // all function overloaded on a symbol.
  Function[] functions;
}

// vim:ts=2 sw=2:
