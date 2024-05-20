`timescale 1ns / 1ps

module decryption_main(
clk,
data,
rx_state,
key,
decrypted_data,
decrypted_data_state
    );
input clk;
input rx_state;
input  [0:127] key;
input  [0:127] data;
output [0:127] decrypted_data;
output decrypted_data_state;


wire  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;

key keygen(key,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);

inverse_main_decrypt decode(clk,data,rx_state,decrypted_data,decrypted_data_state,key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10);

endmodule
