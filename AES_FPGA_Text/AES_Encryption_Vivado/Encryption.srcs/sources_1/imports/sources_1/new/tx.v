`timescale 1ns / 1ps
 


module tx(
    data_state,
    clk,
    data,
    reset,
    out
    );
input data_state;
input clk;
input reset;
input [127:0] data;
output out;

reg [2:0] state=2'd0;
reg [10:0] data_send;
localparam init=2'd0,setup=2'd1,writedata=2'd2;//states

parameter rest=1;

//change these to change baud rate
parameter clock_speed=100000000;//speed of the FPGA clock
parameter baud_rate=9600;//the number of bits you need per second
parameter clock_per_bit=10417;// number of clock cycles your hardware can afford per bit

reg[16:0] clock_counter=13'b0;//counts how many clock cycles passed

reg temp_out=rest;
reg [3:0] bit_counter=0,temp_bit_counter=0;;
reg [3:0] byte_counter;
always@(posedge clk)
begin
case(state)
init:
begin
    temp_out<=1'b1;
    byte_counter<=0;
    if (data_state==1)
    begin
        state<=setup;
    end
end

setup:
begin
    if (reset==1)
    begin
        state<=init;
    end
    else
    begin
      case(byte_counter)
       0:data_send = {1'b1,1'b1,data[127:120],1'b0};
       1:data_send = {1'b1,1'b1,data[119:112],1'b0};
       2:data_send = {1'b1,1'b1,data[111:104],1'b0};
       3:data_send = {1'b1,1'b1,data[103: 96],1'b0};
       4:data_send = {1'b1,1'b1,data[ 95: 88],1'b0};
       5:data_send = {1'b1,1'b1,data[ 87: 80],1'b0};
       6:data_send = {1'b1,1'b1,data[ 79: 72],1'b0};
       7:data_send = {1'b1,1'b1,data[ 71: 64],1'b0};
       8:data_send = {1'b1,1'b1,data[ 63: 56],1'b0};
       9:data_send = {1'b1,1'b1,data[ 55: 48],1'b0};
      10:data_send = {1'b1,1'b1,data[ 47: 40],1'b0};
      11:data_send = {1'b1,1'b1,data[ 39: 32],1'b0};
      12:data_send = {1'b1,1'b1,data[ 31: 24],1'b0};
      13:data_send = {1'b1,1'b1,data[ 23: 16],1'b0};
      14:data_send = {1'b1,1'b1,data[ 15:  8],1'b0};
      15:data_send = {1'b1,1'b1,data[  7:  0],1'b0};
      endcase 

        state<=writedata;
        clock_counter<=clock_per_bit;
        bit_counter<=0;
    end
end

writedata:
begin
if (clock_counter==clock_per_bit)
    begin
        temp_out<=data_send[bit_counter];  
        clock_counter<=0;
        if (bit_counter==10)
        begin
        if (byte_counter==15)
            begin
                state<=init;
             
            end
        else
            begin
                state<=setup;
                byte_counter=byte_counter+1;
            end
        end
        else
        begin
            bit_counter<=bit_counter+1;
        end
     end
else
    begin
        clock_counter<=clock_counter+1;
    end   
end
default:
begin
    state<=init;
end
endcase
end
assign out=temp_out;
endmodule