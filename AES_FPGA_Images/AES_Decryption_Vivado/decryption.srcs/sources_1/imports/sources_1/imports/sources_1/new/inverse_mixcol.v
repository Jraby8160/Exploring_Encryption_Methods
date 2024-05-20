`timescale 1ns / 1ps


module inverse_mixcol(
data_in,
inverse_mixdata
);
input  [0:127] data_in;
output  [0:127] inverse_mixdata;
inv_GF_2_8_multiplier COL1(data_in[0:7],data_in[8:15],data_in[16:23],data_in[24:31],
                      inverse_mixdata[0:7],inverse_mixdata[8:15],inverse_mixdata[16:23],inverse_mixdata[24:31]);
                      
inv_GF_2_8_multiplier COL2(data_in[32:39],data_in[40:47],data_in[48:55],data_in[56:63],
                      inverse_mixdata[32:39],inverse_mixdata[40:47],inverse_mixdata[48:55],inverse_mixdata[56:63]);
                      
inv_GF_2_8_multiplier COL3(data_in[64:71],data_in[72:79],data_in[80:87],data_in[88:95],
                        inverse_mixdata[64:71],inverse_mixdata[72:79],inverse_mixdata[80:87],inverse_mixdata[88:95]);

inv_GF_2_8_multiplier COL4(data_in[96:103],data_in[104:111],data_in[112:119],data_in[120:127],
                      inverse_mixdata[96:103],inverse_mixdata[104:111],inverse_mixdata[112:119],inverse_mixdata[120:127]);
 
endmodule
