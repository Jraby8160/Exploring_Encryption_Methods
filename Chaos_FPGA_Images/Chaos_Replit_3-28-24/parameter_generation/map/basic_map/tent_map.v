module tent_map (
  input wire clk,           // Clock input
  input wire reset,         // Reset input
  input wire [31:0] x_n,    // Current value input
  input wire [31:0] ratio,  // Ratio input
  output reg [31:0] x_next  // Next value output
);

// Always block triggered by positive edge of clock or positive edge of reset
always @(posedge clk or posedge reset) begin
  if (reset) begin // Reset condition
      x_next <= 0; // Reset x_next to 0
  end else begin // Non-reset condition
      if (x_n < 32'h80000000) begin // Check if x_n < 0.5
          // x_next = 2 * ratio * x_n
          x_next <= 32'h00000000; // Initialize x_next to 0
          x_next <= x_next + (ratio * x_n[30:0]); // Multiply and accumulate
      end else begin // x_n >= 0.5
          // x_next = 2 * ratio * (1 - x_n)
          x_next <= 32'h00000000; // Initialize x_next to 0
          x_next <= x_next + (ratio * (32'h3FFFFFFF - x_n[30:0])); // Multiply and accumulate
      end
  end
end

endmodule
