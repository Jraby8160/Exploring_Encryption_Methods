`timescale 1ns / 1ps
`timescale 1ns / 1ps

module decrypt_mid(
            clk,
            data,
            key1,key2,
            data_state,
            encoded_data,
            encoded_state         
    );
input [127:0] data,key1,key2;
input         clk,data_state;
output [127:0]encoded_data;
output        encoded_state;         


//change these to change baud rate
parameter clock_speed=100000000;//speed of the FPGA clock
parameter baud_rate=9600;//the number of bits you need per second
parameter clock_per_bit=10417;// number of clock cycles your hardware can afford per bit


//states
reg state=1'b0;//STATES
localparam init=1'b0,encode=1'b1;//states


reg  [127:0] temp_encoded_data=0;
reg temp_encoded_state=0;;
reg[24:0] clock_counter=25'b0;//counts how many clock cycles passed



wire [127:0] tempered_data1,tempered_data2;

inverse_main_mid   DUM1(data,tempered_data1,key1);
inverse_main_mid   DUM2(tempered_data1,tempered_data2,key2);


always@(posedge clk) begin
case (state)
init:
    begin
    if (clock_counter==clock_per_bit<<4)
    begin
        temp_encoded_state<=1'b0;
    end    
    else    
    begin
        clock_counter<=clock_counter+1;
    end
    
    if (data_state==1)
    begin
        clock_counter<=0;
        state<=encode;
    end
    end
encode:
    begin
    if (clock_counter==clock_per_bit*159)
    begin
       temp_encoded_state<=1'b1;
       temp_encoded_data<=tempered_data2; 
       clock_counter<=0;
       state<=init;  

    end
    else if(clock_counter==clock_per_bit<<4)
    begin
        temp_encoded_state<=1'b0;
        clock_counter<=clock_counter+1;
    end
    else
    begin
        clock_counter<=clock_counter+1;

    end
    end
endcase
end
assign encoded_state=temp_encoded_state;
assign encoded_data=temp_encoded_data;
endmodule


