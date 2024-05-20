`timescale 1ns / 1ps

module main_encrypt(
                        clk,
                        data,
                        rx_state,
                        encrypted_data,
                        encrypted_data_state,
                        key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10
                        );
input          clk,rx_state;
input  [0:127] data;
output [0:127] encrypted_data;
output         encrypted_data_state; 
input  [0:127] key_0,key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10;

wire   [0:127] encoded_data_1,encoded_data_2,encoded_data_3,encoded_data_4;
wire   encoded_state_1, encoded_state_2, encoded_state_3, encoded_state_4;




encrypt_first  first(clk,        data  ,key_0,key_1,key_2,rx_state       ,encoded_data_1,encoded_state_1     );
encrypt_mid    mid1 (clk,encoded_data_1,key_3,key_4      ,encoded_state_1,encoded_data_2,encoded_state_2     );
encrypt_mid    mid2 (clk,encoded_data_2,key_5,key_6      ,encoded_state_2,encoded_data_3,encoded_state_3     );
encrypt_mid    mid3 (clk,encoded_data_3,key_7,key_8      ,encoded_state_3,encoded_data_4,encoded_state_4     );
encrypt_final  last (clk,encoded_data_4,key_9,key_10     ,encoded_state_4,encrypted_data,encrypted_data_state);

//genvar i;
//generate
//    for(i=0;i<9;i=i+1)begin 
//    decrypt_mid RiFA(clk,tempered_data[i],key[9-i],encoded_state[i],tempered_data[i+1],encoded_state[i+1]);
//    end
//endgenerate



//addRoundKey  R1Ak (data_after_subs[9],key[0],decrypted_data); 

endmodule
