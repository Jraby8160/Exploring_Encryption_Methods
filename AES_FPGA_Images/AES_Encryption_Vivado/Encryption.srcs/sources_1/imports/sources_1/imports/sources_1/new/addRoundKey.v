`timescale 1ns / 1ps

module addRoundKey(
    input [127:0] data,
    input [127:0] key,
    output [127:0] data_with_key
    );

assign data_with_key=data^key;
endmodule
