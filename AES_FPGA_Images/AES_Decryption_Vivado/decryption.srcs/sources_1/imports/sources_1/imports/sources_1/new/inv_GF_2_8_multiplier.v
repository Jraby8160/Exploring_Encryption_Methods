`timescale 1ns / 1ps

module inv_GF_2_8_multiplier(
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
        |0E  0B  0D  09|   |data1|
        |09  0E  0B  0D|   |data2|
output= |0D  09  0E  0B| * |data3|
        |0B  0D  09  0E|   |data4|
*/
assign multiplied_data1=multiply_0E(data1)^multiply_0B(data2)^multiply_0D(data3)^multiply_09(data4);
assign multiplied_data2=multiply_09(data1)^multiply_0E(data2)^multiply_0B(data3)^multiply_0D(data4);
assign multiplied_data3=multiply_0D(data1)^multiply_09(data2)^multiply_0E(data3)^multiply_0B(data4);
assign multiplied_data4=multiply_0B(data1)^multiply_0D(data2)^multiply_09(data3)^multiply_0E(data4);

function [7:0] multiply_09(input [7:0]a);
    begin    
    multiply_09=(multiply_02(multiply_02(multiply_02(a)))^ a);
    end
endfunction
function [7:0] multiply_0B(input [7:0]a);
    begin    
    multiply_0B=(multiply_02(multiply_02(multiply_02(a))^a)^a);
    end
endfunction
function [7:0] multiply_0D(input [7:0]a);
    begin    
    multiply_0D=(multiply_02(multiply_02((multiply_02(a)^a)))^a);
    end
endfunction
function [7:0] multiply_0E(input [7:0]a);
    begin    
    multiply_0E=multiply_02(multiply_02(multiply_02(a)^a)^a);
    end
endfunction

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
    begin   
    multiply_03=multiply_02(a)^a;
    end
endfunction      
   
endmodule

