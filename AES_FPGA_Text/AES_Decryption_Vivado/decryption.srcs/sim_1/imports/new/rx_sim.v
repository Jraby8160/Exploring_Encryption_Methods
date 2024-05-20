`timescale 1ns / 1ps
module rx_sim(  );

parameter clock_per_bit=104170*2;// number of clock cycles your hardware can afford per bit
parameter data_size=10;//data size with the noises 
parameter data_freq=16;//stats. freq i.e no of data
parameter data_times=3;
reg clk,data_in;//clocks and the reciever pin
wire  out_tx;
//data to send
//add more data and change data_size and data_freq(data size can be adjusted in the function at the end of program
localparam [7:0]T=8'b01010100;//
localparam [7:0]h=8'b01101000;//
localparam [7:0]e=8'b01100101;//
localparam [7:0]s=8'b00100000;//
localparam [7:0]a=8'b01100001;//
localparam [7:0]r=8'b01110010;//
localparam [7:0]t=8'b01110100 ;//
localparam [7:0]o=8'b01101111;//
localparam [7:0]f=8'b01100110;//
localparam [7:0]c=8'b01100011;//
localparam [7:0]d=8'b01100100;//
localparam [7:0]F=8'b00101110;//

//the function utilizes to create data array with bit conct.
localparam [data_size*data_freq-1:0]data={data_uart(T),data_uart(h),data_uart(e),data_uart(s),data_uart(a),data_uart(r),data_uart(t),data_uart(s),data_uart(o),data_uart(f),data_uart(s),data_uart(c),data_uart(o),data_uart(d),data_uart(e),data_uart(F)};

//wire data_state;
main uut1(
    clk,//clock of fpga
    data_in,// the reciver pin in fpga
    //data_state,
    out_tx // the data obtained
    //data_state
    );
integer i=0,j=0,k=0;//gen varialbes

//begins
initial begin
clk=0;
    for(i=0;i<data_times;i=i+1)
    begin
    for (j=data_freq-1; j>=0; j=j-1)
    begin
    for (k=0; k<data_size; k=k+1)
       begin
        data_in=data[j*data_size+k];
        #clock_per_bit;
       end
    end
    end

end
//runs clock
always 
#10 clk =  ! clk; //oscillate clock betn 0 and 1 every 10 clock cycles i.e 10 ns
//function that inputs data and surround with noises and data send iniater
//mirror image
function [data_size-1:0] data_uart;
    input[7:0] val;
begin
    data_uart={1'b1,val,1'b0};//returns concat.. data
end
endfunction
endmodule
