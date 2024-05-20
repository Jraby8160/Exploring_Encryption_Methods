`timescale 1ns / 1ps
module 
inverse_main_first(
data,
tempered_data,
key_10
    );
input  [0:127] data;
output [0:127] tempered_data;
input  [0:127] key_10;

wire   [0:127] data_with_key;
wire   [0:127] data_after_shift;

    
    
addRoundKey      RFAK (data,key_10,data_with_key);
inv_shift_rows   RFSR (data_with_key,data_after_shift);
inv_substitution RFSB (data_after_shift,tempered_data);
endmodule