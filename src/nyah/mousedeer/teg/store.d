module teg.store;

import teg.sequence;

mixin template store(P) {
}

mixin template store(P...) {
    mixin store!(sequence!(P));
}
