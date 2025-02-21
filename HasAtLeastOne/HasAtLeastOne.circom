pragma circom 2.1.8;

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.
include "../node_modules/circomlib/circuits/comparators.circom";

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    signal check[n];
    var sum = 0;
    for (var i = 0; i < n; i++) {
        check[i] <== IsEqual()([in[i], k]);
        sum += check[i];
    }

    out <== GreaterThan(252)([sum, 0]);
}

component main = HasAtLeastOne(4);
