`timescale 1ns / 1ps



module key( key_in,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);

input [127:0] key_in;
output [127:0] key_0;
output [127:0] key_1;
output [127:0] key_2;
output [127:0] key_3;
output [127:0] key_4;
output [127:0] key_5;
output [127:0] key_6;
output [127:0] key_7;
output [127:0] key_8;
output [127:0] key_9;
output [127:0] key_10;
wire [127:0] key_bus [0:10];
wire [39:0] select_i;
assign key_bus[0] = key_in;
assign select_i = 40'h9876543210;

genvar i;
generate
for( i=0; i<10; i= i+1) begin
aes_key_expand_128 k0(  .select_i(select_i[4*(i+1)-1 : 4*i]), .key(key_bus[i]), .key_out(key_bus[i+1]));

end
endgenerate
assign key_0 = key_bus[0];
assign key_1 = key_bus[1];
assign key_2 = key_bus[2];
assign key_3 = key_bus[3];
assign key_4 = key_bus[4];
assign key_5 = key_bus[5];
assign key_6 = key_bus[6];
assign key_7 = key_bus[7];
assign key_8 = key_bus[8];
assign key_9 = key_bus[9];
assign key_10 = key_bus[10];




endmodule
