`timescale 1ns / 1ps

module rx(
    clk,//clock of fpga
    data_in,// the reciver pin in fpga
    data_state,
    data_out // the data obtained
    );
input clk,data_in;
output [127:0] data_out;
output  data_state;

//change these to change baud rate
parameter clock_speed=100000000;//speed of the FPGA clock
parameter baud_rate=9600;//the number of bits you need per second
parameter clock_per_bit=10417;// number of clock cycles your hardware can afford per bit


//states
reg[1:0] state=2'b0;//STATES
localparam init=2'd0,start=2'd1,readdata=2'd2,stop=2'd3;//states

//registers
reg[24:0] clock_counter=24'b0;//counts how many clock cycles passed
reg[24:0] temp_clock_counter=24'b0;//counts how many clock cycles passed
reg[7:0] output_array=8'b0;//stores the recieved bits
reg[6:0] no_data_recieved=7'b0,temp_no_data_recieved=3'b0;//counts how many data bits recieved
reg[127:0] temp_temp_data_out=128'b0,temp_data_out=128'b0,data_out128=128'b1;//holds 128 bit data

reg temp_data_state=0;
reg [18:0] data_state_counter=0;

always@(posedge clk) begin
case (state)
//stays in idle state
init:
    begin
    if (clock_counter==clock_per_bit<<3)
    begin
    temp_data_state<=1'b0;  
    clock_counter<=0;
    end
    else
    begin
        
        clock_counter<=clock_counter+1;
    end
 
    if(data_in==0)//check for the first 0
    begin
        clock_counter<=0;
        state<=start;//goto next state
    end  
    end
//starts when first 0 is recieved
start:
    begin

    if(clock_counter==(clock_per_bit>>1))// check if half the clock cycles assignes has passed
    begin
        if(data_in==0)//if the input is still 0 or not
        begin
            clock_counter<=0;//reset clock
            state<=readdata;//go to next state
        end
        else
        begin
            state<=init;//else go to the first state
        end      
    end
    else
    begin
        clock_counter<=clock_counter+1;//count to wait the required clock cycles
    
    end
    end
//starts to read data until 8 datas  points are obtained
readdata:
    begin
    if(clock_counter==clock_per_bit)
        begin
            clock_counter<=0;
            output_array<={data_in,output_array[7:1]};// assign the input data
            //uart offers mirror image of data, the trick above helps us to recreate the original data
            no_data_recieved<=temp_no_data_recieved;//counts the total data recieved
            if (&no_data_recieved[2:0])//check if data recieved is seven or not
            begin
                clock_counter<=0;//clears clock
                temp_temp_data_out<=temp_data_out;//calculates once 8 bit data is recieved
                state<=stop;//proceeds to next state
            end
        end
    else
        begin
        clock_counter<=clock_counter+1;//counts till required clock time
        end    
    end
//once 8 bit data are obtained rests until the last enter data settles    
stop:
    begin  
    if(~(|no_data_recieved[6:0]))//7 times 8 bit data is input
        begin
        temp_data_state<=1'b1;            
        end 
    else
        begin
        temp_data_state<=1'b0;   
        end
        
    if(clock_counter==clock_per_bit)//the 10 is used as temporary wait time to proceed to next input
    begin
         clock_counter<=0;//resets clock

        state<=init;//goes to sleep state and awakes if the next input is 0
    end
    else
    begin
    clock_counter<=clock_counter+1;//counts clock cycles
    end
    
    end
//default
default:
    state<=init;
endcase
end
//happens every clock cycles
always@(posedge clk) 
    begin
    temp_no_data_recieved<=no_data_recieved+1;//increments the data collected
    

    if (state==stop)
        begin
        temp_data_out<={temp_temp_data_out[119:0],output_array};//at stop state assignes the collected seven bit data else continues to carry its previoud value

        if(~(|no_data_recieved[6:0]))//7 times 8 bit data is input
            begin
            data_out128<=temp_data_out;//output data
          
            end
        end
  
    if (state==init)
    begin
        if(temp_clock_counter==clock_per_bit*160)
        begin
            data_out128<=128'b1; 
            temp_clock_counter<=0;
        end
        else
        begin
            temp_clock_counter<=temp_clock_counter+1;
        end   
    end
    else
        begin
            temp_clock_counter<=0;
        end
           
end
assign data_state=temp_data_state;
assign data_out=data_out128;

endmodule