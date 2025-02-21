pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if `numerator`,
// `denominator`, `quotient`, and `remainder` represent
// a valid integer division. You will need a comparison check, so
// we've already imported the library and set n to be 252 bits.
//
// Hint: integer division in Circom is `\`.
// `/` is modular division
// `%` is integer modulus

template IntDiv(n) {
    signal input numerator;
    signal input denominator;
    signal input quotient;
    signal input remainder;

    signal checkRemainder;
    signal checkDenominator;

    quotient * denominator + remainder === numerator;
    checkRemainder <== LessEqThan(n)([remainder, denominator]);
    checkDenominator <== LessThan(n)([0, denominator]);

    checkRemainder === 1;
    checkDenominator === 1;
}

component main = IntDiv(252);
