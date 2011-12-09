module beard.functional;

hash_t hashCombine(V)(hash_t seed, auto ref V v) {
    seed ^= v.toHash() + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}
