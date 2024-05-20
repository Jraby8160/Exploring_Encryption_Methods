`timescale 1ns / 1ps



module aes_key_expand_128( select_i, key, key_out);

input [3:0] select_i;
input	[127:0]	key;
output [127:0] key_out;


wire	[31:0]	w[3:0];
wire	[31:0]	tmp_w;
wire	[31:0]	subword;
wire	[31:0]	rcon;
wire [31:0] a,b,c,d;
 



 assign w[0] =  key[127:096];

 assign w[1] =  key[095:064];

 assign w[2] =  key[063:032];

 assign w[3] = key[031:000] ;




assign a =   w[0]^subword^rcon;

assign b =  w[0]^w[1]^subword^rcon;
	
assign c =   w[0]^w[2]^w[1]^subword^rcon;

assign d =  w[0]^w[3]^w[2]^w[1]^subword^rcon;
assign tmp_w = w[3];
aes_sbox u0(	.a(tmp_w[23:16]), .d(subword[31:24]));
aes_sbox u1(	.a(tmp_w[15:08]), .d(subword[23:16]));
aes_sbox u2(	.a(tmp_w[07:00]), .d(subword[15:08]));
aes_sbox u3(	.a(tmp_w[31:24]), .d(subword[07:00]));

aes_rcon r0(  .select_i(select_i),  .out(rcon));

assign key_out ={a,b,c,d};



endmodule

