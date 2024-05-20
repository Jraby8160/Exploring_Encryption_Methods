`timescale 1ns / 1ps

module inverse_main_decrypt(
                        clk,
                        data,
                        rx_state,
                        decrypted_data,
                        decrypted_data_state,
                        key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10
                        );
input          clk,rx_state;
input  [0:127] data;
output [0:127] decrypted_data;
output         decrypted_data_state; 
input  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;

wire   [0:127] key[0:10];
wire   [0:127] encoded_data_1,encoded_data_2,encoded_data_3,encoded_data_4;
wire   encoded_state_1, encoded_state_2, encoded_state_3, encoded_state_4;




decrypt_first  first(clk,data,key_10,key_9,rx_state,encoded_data_1,encoded_state_1);
decrypt_mid    mid1(clk,encoded_data_1,key_8,key_7,encoded_state_1,encoded_data_2,encoded_state_2);
decrypt_mid    mid2(clk,encoded_data_2,key_6,key_5,encoded_state_2,encoded_data_3,encoded_state_3);
decrypt_mid    mid3(clk,encoded_data_3,key_4,key_3,encoded_state_3,encoded_data_4,encoded_state_4);
decrypt_final  last(clk,encoded_data_4,key_2,key_1,key_0,encoded_state_4,decrypted_data,decrypted_data_state);


endmodule
