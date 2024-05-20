`timescale 1ns / 1ps

module main(
    clk,
    data_in,
    data_out_tx
    );
input clk,data_in;
output data_out_tx;

wire data_state,encoded_data_state;
wire [127:0] data_out_rx;//data_out_rx_test;
wire [127:0] encrypted_data;
reg  [127:0] key=128'h5468617473206d79204b756e67204675;


rx         DUT1(clk,data_in,data_state,data_out_rx);
encryption_main DUM(clk,data_out_rx,data_state,key,encrypted_data,encoded_data_state);
tx         DUT3( encoded_data_state, clk, encrypted_data,1'b0, data_out_tx);
//rx      DUT3(clk,data_out_tx,data_state_test,data_out_rx_test);

endmodule
