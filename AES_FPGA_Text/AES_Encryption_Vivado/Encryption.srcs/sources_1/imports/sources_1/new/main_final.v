`timescale 1ns / 1ps
module 
main_final(
data,
tempered_data,
key_10
    );
input  [0:127] data;
output [0:127] tempered_data;
input  [0:127] key_10;

wire   [0:127] data_after_subs;
wire   [0:127] data_after_shift;

substitution RFSB(data,data_after_subs);
shift_rows   RFSR(data_after_subs,data_after_shift);
addRoundKey  RFAk (data_after_shift,key_10,tempered_data); 
endmodule