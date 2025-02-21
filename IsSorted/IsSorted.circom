pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];

    component lt[3];
    for (var i = 0; i < 3; i++) {
        lt[i] = LessEqThan(252);
        lt[i].in[0] <== in[i];
        lt[i].in[1] <== in[i + 1];
        lt[i].out === 1;
    }

}

component main = IsSorted();
