pragma circom 2.1.4;

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'

include "../node_modules/circomlib/circuits/comparators.circom";

template Range() {
    signal input a;
    signal input lowerbound;
    signal input upperbound;
    signal output out;

    signal e1;
    signal e2;
    // Constraint: a must be within the range [lowerbound, upperbound]
    e1 <== LessEqThan(8)([lowerbound, a]);
    e2 <== LessEqThan(8)([a, upperbound]);

    out <== e1 * e2;
}

component main  = Range();
