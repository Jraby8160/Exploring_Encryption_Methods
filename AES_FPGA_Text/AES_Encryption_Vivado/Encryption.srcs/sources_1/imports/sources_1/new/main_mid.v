`timescale 1ns / 1ps
module 
main_mid(
data,
tempered_data,
key
    );
input  [0:127] data;
output [0:127] tempered_data;
input  [0:127] key;

wire   [0:127] data_after_subs;
wire   [0:127] data_after_mixcol;
wire   [0:127] data_after_shift;

    

substitution RiSB(data,data_after_subs);
shift_rows   RiSR(data_after_subs,data_after_shift);
mix_col      RiMC(data_after_shift,data_after_mixcol);   
addRoundKey  RiRK (data_after_mixcol,key,tempered_data); 

endmodule