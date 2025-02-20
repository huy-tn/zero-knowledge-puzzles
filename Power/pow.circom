pragma circom 2.1.4;
include "../node_modules/circomlib/circuits/bitify.circom";

template Power() {
    signal input a[2];   // Input array of length 2
    signal output c;     // Output

    signal exponent_bits[4]; // Assume a[1] is at most 4 bits (modify for larger exponents)
    signal intermediate[4];  // Store intermediate multiplications

    // Bit-decompose the exponent a[1]
    component bitDecomp = Num2Bits(4);
    bitDecomp.in <== a[1];
    for (var i = 0; i < 4; i++) {
        exponent_bits[i] <== bitDecomp.out[i];
    }

    // Compute a[0] ** a[1] using repeated squaring
    intermediate[0] <== a[0];  // Start with base
    for (var i = 1; i < 4; i++) {
        intermediate[i] <== intermediate[i-1] * intermediate[i-1]; // Square the previous value
    }

    // Multiply only selected powers based on bit decomposition
    signal result[5];
    signal temp[4];

    result[0] <== 1;

    for (var i = 0; i < 4; i++) {
        temp[i] <== (exponent_bits[i] * intermediate[i]) + (1 - exponent_bits[i]);
        result[i+1] <== result[i] * temp[i];
    }

    c <== result[4];
}

component main = Power();