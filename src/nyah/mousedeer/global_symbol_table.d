module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Ast, Function, VariableDefinition, Class, Global, GlobalNamespace;
import mousedeer.object_module : ObjectModule;
import mousedeer.io.symbol_table : SymbolTablePrinter;

import beard.variant : Variant;
import beard.io : println, print;

private struct SymbolTableBuilder {
  // current namespace and output module
  GlobalNamespace  namespace_;
  ObjectModule     objModule_;

  // call on every global the first time it is seen
  private void initGlobal(Global g) {
    g.setObjectModule(objModule_);
  }

  void opCall(Function v) {
    initGlobal(v);
    namespace_.symbols_[v.id] = v;
  }
  void opCall(VariableDefinition v) {
    initGlobal(v);
    namespace_.symbols_[v.id] = v;
  }
  void opCall(Class v) {
    initGlobal(v);
    namespace_.symbols_[v.id] = v;
    // TODO: build children
  }

  void empty() { assert(false, "cannot be empty"); }

  void import_(Ast ast) {
    objModule_ = new ObjectModule;
    foreach (node ; ast) {
      node.apply(this);
      // TODO: fill in symbols_ + table and object module for each global in ast
    }
  }
}

class GlobalSymbolTable : GlobalNamespace {
  // import code from ast of single object module into global symbol table
  void import_(Ast ast) {
    SymbolTableBuilder builder;
    builder.namespace_ = this;
    builder.import_(ast);
  }

  void dump() {
    SymbolTablePrinter p;
    p.dump(this);
  }
};
// vim:ts=2 sw=2:
