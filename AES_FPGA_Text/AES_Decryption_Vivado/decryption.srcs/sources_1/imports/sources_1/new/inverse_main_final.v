`timescale 1ns / 1ps
module 
inverse_main_final(
data,
tempered_data,
key_0
    );
input  [0:127] data;
output [0:127] tempered_data;
input  [0:127] key_0;

addRoundKey RFAK (data,key_0,tempered_data);
endmodule