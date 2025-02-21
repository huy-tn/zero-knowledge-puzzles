pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";


// Ensures each row, column, and 2x2 block contains unique numbers from 1 to 4
// template IsPermutation4() {
//     signal input in[4];
//     signal output isValid;
    
//     signal count[4];
//     for (var i = 0; i < 4; i++) {
//         // IsEqual()([in[0], i+1])
//         // IsEqual()([in[0], i+1])
//         // IsEqual()([in[0], i+1])
//         // IsEqual()([in[0], i+1])
//         count[i] <== IsEqual()([in[0], i+1]) + IsEqual()([in[1], i+1]) + IsEqual()([in[2], i+1]) + IsEqual()([in[3], i+1]);
//     }
    
//     isValid <== (count[0] == 1) * (count[1] == 1) * (count[2] == 1) * (count[3] == 1);
// }


template IsPermutation4 {
    signal input in[4];
    signal output isValid;
    
    component checks[4][4];
    signal out[4];
    
    var count_value[4];
    for (var i = 0; i < 4; i++) {
        count_value[i] = 0;
        for (var j = 0; j < 4; j++) {
            checks[i][j] = IsEqual();
            checks[i][j].in[0] <== in[j];
            checks[i][j].in[1] <== i + 1;
            count_value[i] += checks[i][j].out;
        }
        out[i] <== count_value[i];
    }
    
    // Ensure each number appears exactly once (all counts must be 1)
    component eqChecks[4];
    for (var i = 0; i < 4; i++) {
        eqChecks[i] = IsEqual();
        eqChecks[i].in[0] <== out[i];
        eqChecks[i].in[1] <== 1;
    }

    component andGates[3];
    andGates[0] = AND();
    andGates[0].a <== eqChecks[0].out;
    andGates[0].b <== eqChecks[1].out;
    
    andGates[1] = AND();
    andGates[1].a <== andGates[0].out;
    andGates[1].b <== eqChecks[2].out;
    
    andGates[2] = AND();
    andGates[2].a <== andGates[1].out;
    andGates[2].b <== eqChecks[3].out;
    
    isValid <== andGates[2].out;
}


template Sudoku() {
    signal input question[16];
    signal input solution[16];
    signal output out;

    // Ensure solution respects the question (pre-filled values must remain the same)
    for (var i = 0; i < 16; i++) {
        assert(question[i] == 0 || question[i] == solution[i]);
    }

    // Constraints for rows, columns, and 2x2 blocks
    component rowChecks[4];
    component colChecks[4];
    component boxChecks[4];

    for (var i = 0; i < 4; i++) {
        rowChecks[i] = IsPermutation4();
        colChecks[i] = IsPermutation4();
    }

    for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
            rowChecks[i].in[j] <== solution[i * 4 + j];
            colChecks[j].in[i] <== solution[i * 4 + j];
        }
    }

    // 2x2 box uniqueness constraints
    for (var b = 0; b < 4; b++) {
        boxChecks[b] = IsPermutation4();
    }

    boxChecks[0].in[0] <== solution[0];  boxChecks[0].in[1] <== solution[1];  boxChecks[0].in[2] <== solution[4];  boxChecks[0].in[3] <== solution[5];
    boxChecks[1].in[0] <== solution[2];  boxChecks[1].in[1] <== solution[3];  boxChecks[1].in[2] <== solution[6];  boxChecks[1].in[3] <== solution[7];
    boxChecks[2].in[0] <== solution[8];  boxChecks[2].in[1] <== solution[9];  boxChecks[2].in[2] <== solution[12]; boxChecks[2].in[3] <== solution[13];
    boxChecks[3].in[0] <== solution[10]; boxChecks[3].in[1] <== solution[11]; boxChecks[3].in[2] <== solution[14]; boxChecks[3].in[3] <== solution[15];

    component andGates[11];

    // First level of ANDs
    andGates[0] = AND();
    andGates[0].a <== rowChecks[0].isValid;
    andGates[0].b <== rowChecks[1].isValid;

    andGates[1] = AND();
    andGates[1].a <== rowChecks[2].isValid;
    andGates[1].b <== rowChecks[3].isValid;

    andGates[2] = AND();
    andGates[2].a <== colChecks[0].isValid;
    andGates[2].b <== colChecks[1].isValid;

    andGates[3] = AND();
    andGates[3].a <== colChecks[2].isValid;
    andGates[3].b <== colChecks[3].isValid;

    andGates[4] = AND();
    andGates[4].a <== boxChecks[0].isValid;
    andGates[4].b <== boxChecks[1].isValid;

    andGates[5] = AND();
    andGates[5].a <== boxChecks[2].isValid;
    andGates[5].b <== boxChecks[3].isValid;

    // Second level of ANDs
    andGates[6] = AND();
    andGates[6].a <== andGates[0].out;
    andGates[6].b <== andGates[1].out;

    andGates[7] = AND();
    andGates[7].a <== andGates[2].out;
    andGates[7].b <== andGates[3].out;

    andGates[8] = AND();
    andGates[8].a <== andGates[4].out;
    andGates[8].b <== andGates[5].out;

    // Third level of ANDs
    andGates[9] = AND();
    andGates[9].a <== andGates[6].out;
    andGates[9].b <== andGates[7].out;

    andGates[10] = AND();
    andGates[10].a <== andGates[8].out;
    andGates[10].b <== andGates[9].out;

    // Final output
    out <== andGates[10].out;
}

component main = Sudoku();
