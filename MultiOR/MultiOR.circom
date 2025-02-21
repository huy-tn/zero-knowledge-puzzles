pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that returns true when at least one
// element is 1. It should return false if all elements
// are 0. It should be unsatisfiable if any of the inputs
// are not 0 or not 1.

template MultiOR(n) {
    signal input in[n];
    signal output out;

    var sum = 0;
    for (var i = 0; i < n; i++) {
        in[i] * in[i] === in[i];
        sum += sum + in[i];
    }

    component check = IsZero();
    check.in <== sum;
    
    out <== 1 - check.out;
}

component main = MultiOR(4);
