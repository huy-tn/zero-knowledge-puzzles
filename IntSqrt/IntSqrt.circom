pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if
// in[0] is the floor of the integer
// sqrt of in[1]. For example:
// 
// int[2, 5] accept
// int[2, 5] accept
// int[2, 9] reject
// int[3, 9] accept
//
// If b is the integer square root of a, then
// the following must be true:
//
// (b - 1)(b - 1) < a
// (b + 1)(b + 1) > a
// 
// be careful when verifying that you 
// handle the corner case of overflowing the 
// finite field. You should validate integer
// square roots, not modular square roots

template IntSqrt(n) {
    signal input in[2];  // in[0] = b (sqrt candidate), in[1] = a (number)
    
    signal b_minus_1, b_plus_1;
    signal b_minus_1_sq, b_plus_1_sq;

    // Compute (b - 1) and (b + 1)
    b_minus_1 <== in[0] - 1;
    b_plus_1 <== in[0] + 1;

    // Compute (b - 1)^2 and (b + 1)^2
    b_minus_1_sq <== b_minus_1 * b_minus_1;
    b_plus_1_sq <== b_plus_1 * b_plus_1;

    component maxCheck = LessThan(n);
    maxCheck.in[0] <== in[0];
    maxCheck.in[1] <== 2**((n - 1) / 2);  // Prevent field overflow issues
    maxCheck.out === 1;

    // Constraints to enforce integer sqrt properties
    component isLessThan = LessThan(n);
    component isGreaterThan = LessThan(n);

    isLessThan.in[0] <== b_minus_1_sq;
    isLessThan.in[1] <== in[1];  // (b - 1)^2 < a

    isGreaterThan.in[0] <== in[1];
    isGreaterThan.in[1] <== b_plus_1_sq;  // a < (b + 1)^2

    isLessThan.out === 1;
    isGreaterThan.out === 1;
}


component main = IntSqrt(252);
