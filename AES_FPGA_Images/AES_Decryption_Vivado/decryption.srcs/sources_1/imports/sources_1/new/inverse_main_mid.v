`timescale 1ns / 1ps
module 
inverse_main_mid(
data,
tempered_data,
key
    );
input  [0:127] data;
output [0:127] tempered_data;
input  [0:127] key;

wire   [0:127] data_with_key;
wire   [0:127] data_after_mixcol;
wire   [0:127] data_after_shift;

    
    
addRoundKey      RiAk(data,key,data_with_key);
inverse_mixcol   RiMC(data_with_key,data_after_mixcol);  
inv_shift_rows   RiSR(data_after_mixcol,data_after_shift);  
inv_substitution RiSB(data_after_shift,tempered_data); 

endmodule