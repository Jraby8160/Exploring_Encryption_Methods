`timescale 1ns / 1ps

module GF_2_8_multiplier(
data1,
data2,
data3,
data4,
multiplied_data1,
multiplied_data2,
multiplied_data3,
multiplied_data4
                        );
                        
input [7:0] data1,data2,data3,data4;
output [7:0] multiplied_data1, multiplied_data2, multiplied_data3, multiplied_data4;
/*Multiplication Matrix for Mix Col
        |02  03  01  01|   |data1|
        |01  02  03  01|   |data2|
output= |01  01  02  03| * |data3|
        |03  01  01  02|   |data4|
*/
assign multiplied_data1=multiply_02(data1)^multiply_03(data2)^multiply_01(data3)^multiply_01(data4);
assign multiplied_data2=multiply_01(data1)^multiply_02(data2)^multiply_03(data3)^multiply_01(data4);
assign multiplied_data3=multiply_01(data1)^multiply_01(data2)^multiply_02(data3)^multiply_03(data4);
assign multiplied_data4=multiply_03(data1)^multiply_01(data2)^multiply_01(data3)^multiply_02(data4);


function [7:0] multiply_01(input [7:0]a);
    begin    
    multiply_01=a;
    end
endfunction
function [7:0] multiply_02(input [7:0]a);
    begin    
    if (a[7]==0) begin        
        multiply_02=a<<1; 
    end else begin
        multiply_02=(a<<1)^8'b00011011;
    end
    end
endfunction  

function [7:0] multiply_03(input [7:0]a);
    reg [7:0]temp;
    begin   
    temp=multiply_02(a);
    multiply_03=temp^a;
    end
endfunction      
   
endmodule

