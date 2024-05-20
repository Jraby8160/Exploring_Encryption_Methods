`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2020 06:59:13 AM
// Design Name: 
// Module Name: c
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module aes_rcon(select_i, out);

input [3:0] select_i;
output	[31:0]	out;
reg	[31:0]	rco;
assign out = rco;


always@(select_i)
begin
case(select_i)	
   4'h0: rco =32'h00_00_00_00;
   4'h1: rco =32'h01_00_00_00;
   4'h2: rco=32'h02_00_00_00;
   4'h3: rco=32'h04_00_00_00;
   4'h4: rco=32'h08_00_00_00;
   4'h5: rco=32'h10_00_00_00;
   4'h6: rco=32'h20_00_00_00;
   4'h7: rco=32'h40_00_00_00;
   4'h8: rco=32'h80_00_00_00;
   4'h9: rco=32'h1b_00_00_00;
   4'ha: rco=32'h36_00_00_00;
   default: rco=32'h00_00_00_00;
endcase
end

endmodule
