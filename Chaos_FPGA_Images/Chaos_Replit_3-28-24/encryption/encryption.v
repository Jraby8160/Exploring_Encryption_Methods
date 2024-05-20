module encryption(
  input [7:0] image [0:255][0:255], // Assuming 256x256 pixels image
  input [7:0] K,
  input [7:0] F,
  output [7:0] image_encrypted [0:255][0:255]
);

reg [7:0] image_encrypted [0:255][0:255];
reg [7:0] Lm, Ln, m, n, a, u;
reg [7:0] M [0:255][1];
reg [7:0] N [1][0:255];
reg [1:0] xl, xr, r1, r2; // Added registers to hold parameter_gen outputs

// Instantiate parameter_gen module
parameter_gen param_gen (
  .K(K),
  .xl(xl),
  .xr(xr),
  .r1(r1),
  .r2(r2)
);

// Instantiate key_expansion module
key_expansion key_exp (
  .clk(clk), // Assuming a clock input is present
  .m(m),
  .n(n),
  .r1(r1),
  .r2(r2),
  .M_out(M),
  .N_out(N)
);

// Instantiate permutation module
permutation perm_inst (
  .image(image),
  .M(M),
  .N(N),
  .permutated_image(image_encrypted)
);

// Instantiate substitution module
substitution sub_inst (
  .image(image_encrypted),
  .M(M[0][0]), // Assuming M[0][0] holds the key parameter M
  .N(N[0][0]), // Assuming N[0][0] holds the key parameter N
  .F(F),
  .substituted_image(image_encrypted)
);

// Extracting shape of the image
assign {Lm, Ln} = $dimensions(image);

// Extracting parameters from the key
// Assuming parameter function outputs parameters into these registers
// Assign values from parameter_gen outputs to corresponding registers
always @* begin
  m = xl;
  n = xr;
  a = r1;
  u = r2;
end

// Two rounds of encryption
integer i;
always @(*) begin
  for (i = 0; i < 2; i = i + 1) begin
    permutation perm (
      .image(image),
      .M(M),
      .N(N),
      .image_encrypted(image_encrypted)
    );
    substitution sub (
      .image(image_encrypted),
      .M(M),
      .N(N),
      .F(F),
      .image_encrypted(image_encrypted)
    );
  end
end

endmodule
