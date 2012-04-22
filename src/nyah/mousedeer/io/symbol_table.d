module mousedeer.io.symbol_table;

import mousedeer.parser.nyah
  : Function, VariableDefinition, Class, GlobalNamespace, Module, Global;

import beard.io : println, print;
import std.stdio : writeln;

struct SymbolTablePrinter {
  enum TAB_SIZE = 2;
  bool verbose;

  private void printModule(Module v) {
    print("module ");
    print(v.ids()[0].str);
    foreach (id ; v.ids()[1..$])
      print("." ~ id.str);
  }

  private void printGlobal(Global v) {
    if (! verbose) return;
    print(" - parent [");
    v.parent_.apply(
        (Class v) { print("class", v.id); },
        &printModule,
        (VariableDefinition v) { assert(false, "variable definition for parent"); },
        (Function v) { print("func", v.id); },
        () { print("empty"); });
    print("]");
  }

  void opCall(Function v) {
    print("function");
    printGlobal(v);
    writeln();
  }
  void opCall(VariableDefinition v) {
    print("variable definition");
    printGlobal(v);
    writeln();
  }
  void opCall(Module v) {
    print("module");
    printGlobal(v);
    children(v);
  }
  void opCall(Class v) {
    print("class");
    printGlobal(v);
    children(v);
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
// vim:ts=2 sw=2:
