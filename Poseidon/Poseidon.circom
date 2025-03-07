pragma circom 2.1.4;


// Go through the circomlib library and import the poseidon hashing template using node_modules
// Input 4 variables,namely,'a','b','c','d' , and output variable 'out' .
// Now , hash all the 4 inputs using poseidon and output it . 
include "../node_modules/circomlib/circuits/poseidon.circom";

template poseidon() {
    signal input a;
    signal input b;
    signal input c;
    signal input d;
    signal output out;

    // Instantiate the Poseidon hash function with 4 inputs
    component hash = Poseidon(4);

    // Connect inputs to the Poseidon hash
    hash.inputs[0] <== a;
    hash.inputs[1] <== b;
    hash.inputs[2] <== c;
    hash.inputs[3] <== d;

    // Assign output
    out <== hash.out;
}


component main = poseidon();