module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Ast, Function, VariableDefinition, Class, Global, GlobalNamespace;
import mousedeer.object_module : ObjectModule;
import mousedeer.io.symbol_table : SymbolTablePrinter;

import beard.variant : Variant;
import beard.io : println, print;

private struct SymbolTableBuilder {
  Global current;
  ObjectModule currentModule_;

  // call on every global the first time it is seen
  private void initGlobal(Global g) {
    g.setObjectModule(currentModule_);
  }

  void opCall(Function v) { initGlobal(v); }
  void opCall(VariableDefinition v) { initGlobal(v); }
  void opCall(Class v) {
    initGlobal(v);
    // TODO: build children
  }

  void empty() { assert(false, "cannot be empty"); }

  void import_(ObjectModule module_, Ast ast) {
    currentModule_ = module_;
    foreach (node ; ast) {
      node.apply(this);
      // TODO: fill in symbols_ + table and object module for each global in ast
    }
  }
}

class GlobalSymbolTable : GlobalNamespace {
  // import code from ast of single object module into global symbol table
  void import_(ObjectModule module_, Ast ast) {
    SymbolTableBuilder builder;
    builder.current = this;
    builder.import_(module_, ast);
  }

  void dump() {
    SymbolTablePrinter p;
    p.dump(this);
  }
};
// vim:ts=2 sw=2:
