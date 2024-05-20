module parameter_gen (
  input logic [255:0] K,
  output logic [1:0] xl,
  output logic [1:0] xr,
  output logic [1:0] r1,
  output logic [1:0] r2
);

// Declaring variables
logic [63:0] Xl [0:1];
logic [63:0] XR [0:1];
logic [31:0] R [0:1];
integer S;

// Calculate Xl, XR, and R
always_comb begin
  S = $countones(K);

  for (int i = 0; i < 2; i++) begin
      Xl[i] = K[i*64 +: 64];
      XR[i] = K[i*64 + 64 +: 64];
      R[i] = Xl[i] ^ XR[i];
  end
end

// Calculate xl, xr, r1, and r2
always_comb begin
  for (int i = 0; i < 2; i++) begin
      xl[i] = (S == 0) ? 0 : ($countones(Xl[i]) / S);
      xr[i] = (S == 0) ? 0 : ($countones(XR[i]) / S);
      r1[i] = (S == 0) ? 0.5 : (0.3 + ($countones(R[i][31:0]) / 32) * 0.7);
      r2[i] = (S == 0) ? 0.5 : (0.3 + ($countones(R[i][63:32]) / 32) * 0.7);
  end
end

endmodule

/*
This code takes in K and outputs xl, xr, r1, and r2.

Xl and XR are the left and right halves of K, a 256 bit input.
x1, xr, r1, and r2 are the ratios of ones in each half and in the lower
and upper halves of R, which is an XOR of Xl and XR

$countones() counts the number of ones in the argument

Input: K
Output: xl, xr, r1, r2
*/