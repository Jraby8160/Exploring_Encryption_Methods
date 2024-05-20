module v18 (
  input wire [31:0] x0,
  input wire [31:0] rfs,
  input wire [31:0] rs,
  output reg [31:0] x_next
);

// Internal variables
reg [31:0] a1;
reg [31:0] a2;
reg [31:0] flipped_sine;
reg [31:0] sine;

// Instantiate flipped_sine_map module
flipped_sine_map flipped_sine_inst (
  .x_n(x0),            // Connect x_n to x0
  .ratio(rfs),         // Connect ratio to rfs
  .x_next(flipped_sine) // Output flipped_sine
);

// Instantiate sine_map module
sine_map sine_inst (
  .x_n(x0),       // Connect x_n to x0
  .ratio(rs),    // Connect ratio to rs
  .x_next(sine)  // Output sine
);

// Always block to compute x_next
always @* begin
  // Constants
  a1 = 32'h00000001; // Assign 1 to a1
  a2 = 32'h00000000; // Assign 0 to a2

  // Compute x_next = (a1 * flipped_sine + a2 * sine) / (flipped_sine + sine)
  x_next = (a1 * flipped_sine + a2 * sine) / (flipped_sine + sine);
end

endmodule