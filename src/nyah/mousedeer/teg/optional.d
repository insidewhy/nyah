module teg.optional;

import teg.choice;
import teg.empty_string;
import teg.sequence;

class Optional(T...) if (T.length > 1) : Choice!(Sequence!T, EmptyString) {}

class Optional(T) : Choice!(T, EmptyString) {}
