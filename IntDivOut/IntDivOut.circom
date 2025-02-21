pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;

    signal remainder;

    signal checkRemainder;
    signal checkDenominator;

    checkDenominator <== LessThan(n)([0, denominator]);
    checkDenominator === 1;

    out <-- numerator \ denominator;
    remainder <-- numerator % denominator;

    checkRemainder <== LessThan(n)([remainder, denominator]);
    checkRemainder === 1;

    out * denominator + remainder === numerator;
}

component main = IntDivOut(252);
