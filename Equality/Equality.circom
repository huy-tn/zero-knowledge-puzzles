pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.
template IsZero() {
  signal input in;
  signal output out;

  signal inv <-- in != 0 ? 1 / in : 0;
  out <== 1 - (in * inv);

  in * out === 0;
}

template IsEqual() {
  signal input in[2];
  signal output out;

  out <== IsZero()(in[1] - in[0]);
}

template Equality() {
   // Your Code Here..
   signal input a[3];  // Array of 3 elements
   signal output out;  // Output 1 if all are equal, else 0

   component c1 = IsEqual();
   component c2 = IsEqual();

   c1.in[1] <== a[0];
   c1.in[0] <== a[1];

   c2.in[1] <== a[1];
   c2.in[0] <== a[2];

   out <== c1.out * c2.out;
}

component main = Equality();