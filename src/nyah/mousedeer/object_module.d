module mousedeer.object_module;

// represent a module output to a llvm bytecode file.
// One nyah module is composed of one or more object modules.
// Each file may contain one or more object modules.
// An object module is the smallest of:
//     The code in one source file.
//     The code in one module.
// Therefore a single module split over multiple files becomes multiple object
// modules. A single file containing multiple modules will contain an object
// module for each source module.
class ObjectModule {
  this(string path_) {
    static uint lastId = 0;
    path = path_;
    id   = ++lastId;
  }

  uint   id;
  // path to bytecode file (relative to configured bytecode output path)
  string path;
}
// vim:ts=2 sw=2:
