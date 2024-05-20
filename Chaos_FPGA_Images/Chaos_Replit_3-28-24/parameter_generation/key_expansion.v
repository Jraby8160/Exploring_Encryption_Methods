module key_expansion(
  input clk,
  input int m,
  input int n,
  input int r1,
  input int r2,
  output int M_out[256][1],
  output int N_out[1][256]
);

// Define internal variables
int i;
int M[256][1] = '{default:0};
int N[1][256] = '{default:0};

// Internal wires to connect v18 modules
wire [31:0] x_next_M, x_next_N;

// Instantiate v18 modules for M and N calculations
v18 v18_M (
  .x0(M[i-1][0]), // Connect x0 to M[i-1][0]
  .rfs(r1),       // Connect rfs to r1
  .rs(r2),        // Connect rs to r2
  .x_next(x_next_M) // Output x_next for M
);

v18 v18_N (
  .x0(N[0][i-1]), // Connect x0 to N[0][i-1]
  .rfs(r2),       // Connect rfs to r2
  .rs(r1),        // Connect rs to r1
  .x_next(x_next_N) // Output x_next for N
);

// Calculate M and N values
always_ff @(posedge clk) begin
  M[0][0] = m;
  N[0][0] = n;
  for (i = 1; i < 256; i = i + 1) begin
      M[i][0] <= x_next_M;
      N[0][i] <= x_next_N;
  end
end

// Assign M and N to output ports
assign M_out = M;
assign N_out = N;

endmodule