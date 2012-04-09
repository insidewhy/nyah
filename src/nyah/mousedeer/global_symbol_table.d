module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Ast, Function, VariableDefinition, Class, Global, GlobalNamespace;
import mousedeer.object_module : ObjectModule;

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

private struct SymbolTablePrinter {
  enum TAB_SIZE = 2;

  void opCall(Function f) {
    println("function");
  }
  void opCall(VariableDefinition v) {
    println("variable definition");
  }
  void opCall(Class c) {
    print("class");
    children(c);
  }

  private void printIndent() {
    for (int i = 0; i < indent_; ++i)
      for (int j = 0; j < TAB_SIZE; ++j)
        print(' ');
  }

  private void children(GlobalNamespace val) {
    println(" {");
    ++indent_;
    foreach(k, v; val.symbols_) {
      printIndent();
      print(k, " : ");
      v.apply(this);
    }
    --indent_;
    printIndent();
    println("}");
  }

  void dump(GlobalNamespace root) {
    print("global");
    children(root);
  }

  void empty() { assert(false, "cannot be empty"); }

  int indent_ = 0;
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
