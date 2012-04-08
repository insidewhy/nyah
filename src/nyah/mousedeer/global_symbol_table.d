module mousedeer.global_symbol_table;

import mousedeer.parser.nyah : Ast, Function, VariableDefinition, Class, Global;
import mousedeer.object_module : ObjectModule;
import beard.variant : Variant;

private struct SymbolTableBuilder {
  Global current;

  void opCall(Function f) { }
  void opCall(VariableDefinition v) { }
  void opCall(Class c) { }

  void empty() { assert(false, "cannot be empty"); }

  void import_(ObjectModule module_, Ast ast) {
    foreach (node ; ast) {
      node.apply(this);
      // TODO: fill in symbols_ + table and object module for each global in ast
    }
  }
}

class GlobalSymbolTable : Global {
  // import code from ast of single object module into global symbol table
  void import_(ObjectModule module_, Ast ast) {
    SymbolTableBuilder builder;
    builder.current = this;
    builder.import_(module_, ast);
  }

  void dump() {
    // TODO:
  }
};
// vim:ts=2 sw=2:
