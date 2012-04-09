module mousedeer.io.symbol_table;

import mousedeer.parser.nyah
  : Function, VariableDefinition, Class, GlobalNamespace;

import beard.io : println, print;

struct SymbolTablePrinter {
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
      print(k ~ ": ");
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

