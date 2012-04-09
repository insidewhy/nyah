module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Ast, Function, VariableDefinition, Class, Global, GlobalNamespace, Module;
import mousedeer.object_module : ObjectModule;
import mousedeer.io.symbol_table : SymbolTablePrinter;

import beard.variant : Variant;
import beard.io : println, print;

private struct SymbolTableBuilder {
  // current namespace and output module
  Global.Ptr       parent_;
  GlobalNamespace  namespace_;
  ObjectModule     objModule_;

  // call on every global the first time it is seen
  private void initGlobal(Global g) {
    g.parent_ = parent_;
    g.setObjectModule(objModule_);
  }

  void opCall(T)(T v) {
    static if (is(T : Module)) {
      // re-use existing module if the current module was never used
      if (! namespace_.symbols_.length)
        objModule_ = new ObjectModule;

      parent_.reset;
      initGlobal(v);
      foreach(id; v.ids()) {
        // TODO: ensure each component exists in the symbol table and add
        //       the last one
      }
      return;
    }
    else static if (is(T : Global)) {
      initGlobal(v);
      namespace_.symbols_[v.id] = v;
    }

    static if (is(T : Class)) {
      auto namespaceBak = namespace_;
      auto parentBak    = parent_;
      namespace_ = v;
      parent_ = v;

      foreach (node ; v.block.value_)
        node.apply(this);

      namespace_ = namespaceBak;
      parent_ = parentBak;
    }
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
