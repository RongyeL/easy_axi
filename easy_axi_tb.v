// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : easy_axi_tb.v
// Author        : Rongye
// Created On    : 2022-12-24 05:15
// Last Modified : 2022-12-30 20:09
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ps

module EASY_AXI_TB();

reg         clk;
reg         rst_n;
reg         txn_start;
reg  [1:0]  txn_type; // 00->none  01->write transacation  10->read transacation  11->reserved
wire        txn_done;

initial begin 
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n     = 0;
    txn_start = 0;
    txn_type  = 2'b00;
#50
    rst_n     = 1;
#100
    start_write;
#500
    start_write;
#500
    start_read;
#500
    start_read;
#500
    start_write;
#500
    start_read;
#500
    start_read;
#500
    $stop;
end

EASY_AXI #(
    .TARGET_SLAVE_BASE_ADDR         ( 32'h40000000                  ),
    .AXI_BURST_LEN                  ( 16                             ),
    .AXI_ID_WIDTH                   ( 1                             ),
    .AXI_ADDR_WIDTH                 ( 32                            ),
    .AXI_DATA_WIDTH                 ( 32                            ))
U_EASY_AXI_0(
    .clk                            ( clk                           ),
    .rst_n                          ( rst_n                         ),
    .txn_start                      ( txn_start                     ),
    .txn_type                       ( txn_type                      ),
    .txn_done                       ( txn_done                      )
);

task start_write; 
    begin
    txn_type  = 2'b01;
    txn_start = 1;
    #50
    txn_start = 0;
    end
endtask

task start_read; 
    begin
    txn_type  = 2'b10;
    txn_start = 1;
    #50
    txn_start = 0;
    end
endtask

initial begin
    $dumpfile("easy_axi_tb.vcd");
    $dumpvars;
end


endmodule

