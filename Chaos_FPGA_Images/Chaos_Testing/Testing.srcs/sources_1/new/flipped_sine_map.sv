module flipped_sine_map (
  input wire [31:0] x_n,    // Input value x_n
  input wire [31:0] ratio,  // Input value ratio
  output reg [31:0] x_next  // Output value x_next
);

// Internal variables
reg [31:0] sin_value;

// Always block to compute x_next
always @* begin
  // Calculate sine value using sin function
  sin_value = $signed($rtoi($sin(x_n * 32'h3243F6A8))); // Convert the result to signed integer

  // Compute x_next = ratio - ratio * sin(pi * x_n)
  x_next = ratio - ratio * sin_value;
end

endmodule
