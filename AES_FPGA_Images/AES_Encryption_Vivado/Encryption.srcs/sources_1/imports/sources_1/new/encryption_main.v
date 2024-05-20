`timescale 1ns / 1ps

module encryption_main(
clk,
data,
rx_state,
key,
encrypted_data,
encrypted_data_state
    );
input clk;
input rx_state;
input  [0:127] key;
input  [0:127] data;
output [0:127] encrypted_data;
output encrypted_data_state;


wire  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;

key keygen(key,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);

main_encrypt encode(clk,data,rx_state,encrypted_data,encrypted_data_state,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);

endmodule
