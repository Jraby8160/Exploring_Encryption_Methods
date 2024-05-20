`timescale 1ns / 1ps


module mix_col(
data_in,
mix_data
);
input  [0:127] data_in;
output  [0:127] mix_data;
GF_2_8_multiplier COL1(data_in[0:7],data_in[8:15],data_in[16:23],data_in[24:31],
                      mix_data[0:7],mix_data[8:15],mix_data[16:23],mix_data[24:31]);
                      
GF_2_8_multiplier COL2(data_in[32:39],data_in[40:47],data_in[48:55],data_in[56:63],
                      mix_data[32:39],mix_data[40:47],mix_data[48:55],mix_data[56:63]);
                      
GF_2_8_multiplier COL3(data_in[64:71],data_in[72:79],data_in[80:87],data_in[88:95],
                        mix_data[64:71],mix_data[72:79],mix_data[80:87],mix_data[88:95]);

GF_2_8_multiplier COL4(data_in[96:103],data_in[104:111],data_in[112:119],data_in[120:127],
                      mix_data[96:103],mix_data[104:111],mix_data[112:119],mix_data[120:127]);
 
endmodule
