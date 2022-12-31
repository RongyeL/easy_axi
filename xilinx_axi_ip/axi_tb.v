// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : axi_mst_tb.v
// Author        : Rongye
// Created On    : 2022-12-24 05:15
// Last Modified : 2022-12-26 23:53
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`timescale 1ns/1ps

module AXI_TB();
		parameter TARGET_SLAVE_BASE_ADDR	= 32'h40000000;
		parameter integer AXI_BURST_LEN	= 16;
		parameter integer AXI_ID_WIDTH	= 1;
		parameter integer AXI_ADDR_WIDTH	= 32;
		parameter integer AXI_DATA_WIDTH	= 32;
		parameter integer AXI_AWUSER_WIDTH	= 0;
		parameter integer AXI_ARUSER_WIDTH	= 0;
		parameter integer AXI_WUSER_WIDTH	= 0;
		parameter integer AXI_RUSER_WIDTH	= 0;
		parameter integer AXI_BUSER_WIDTH	= 0;
reg clk;
reg rst_n;
reg  INIT_AXI_TXN;
wire  TXN_DONE;
wire  ERROR;

wire  AXI_ACLK;
wire  AXI_ARESETN;
wire [AXI_ID_WIDTH-1 : 0] AXI_AWID;
wire [AXI_ADDR_WIDTH-1 : 0] AXI_AWADDR;
wire [7 : 0] AXI_AWLEN;
wire [2 : 0] AXI_AWSIZE;
wire [1 : 0] AXI_AWBURST;
wire  AXI_AWLOCK;
wire [3 : 0] AXI_AWCACHE;
wire [2 : 0] AXI_AWPROT;
wire [3 : 0] AXI_AWQOS;
wire [3 : 0] AXI_AWREGION;
wire [AXI_AWUSER_WIDTH-1 : 0] AXI_AWUSER;
wire  AXI_AWVALID;
wire  AXI_AWREADY;
wire [AXI_DATA_WIDTH-1 : 0] AXI_WDATA;
wire [(AXI_DATA_WIDTH/8)-1 : 0] AXI_WSTRB;
wire  AXI_WLAST;
wire [AXI_WUSER_WIDTH-1 : 0] AXI_WUSER;
wire  AXI_WVALID;
wire  AXI_WREADY;
wire [AXI_ID_WIDTH-1 : 0] AXI_BID;
wire [1 : 0] AXI_BRESP;
wire [AXI_BUSER_WIDTH-1 : 0] AXI_BUSER;
wire  AXI_BVALID;
wire  AXI_BREADY;
wire [AXI_ID_WIDTH-1 : 0] AXI_ARID;
wire [AXI_ADDR_WIDTH-1 : 0] AXI_ARADDR;
wire [7 : 0] AXI_ARLEN;
wire [2 : 0] AXI_ARSIZE;
wire [1 : 0] AXI_ARBURST;
wire  AXI_ARLOCK;
wire [3 : 0] AXI_ARCACHE;
wire [2 : 0] AXI_ARPROT;
wire [3 : 0] AXI_ARQOS;
wire [3 : 0] AXI_ARREGION;
wire [AXI_ARUSER_WIDTH-1 : 0] AXI_ARUSER;
wire  AXI_ARVALID;
wire  AXI_ARREADY;
wire [AXI_ID_WIDTH-1 : 0] AXI_RID;
wire [AXI_DATA_WIDTH-1 : 0] AXI_RDATA;
wire [1 : 0] AXI_RRESP;
wire  AXI_RLAST;
wire [AXI_RUSER_WIDTH-1 : 0] AXI_RUSER;
wire  AXI_RVALID;
wire  AXI_RREADY;


initial begin 
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n         = 0;
    INIT_AXI_TXN  = 0;
#50
    rst_n         = 1;
    INIT_AXI_TXN  = 1;

#2500
    $stop;
end

assign AXI_ACLK = clk;
assign AXI_ARESETN = rst_n;


M_AXI #(
    .C_M_TARGET_SLAVE_BASE_ADDR     ( TARGET_SLAVE_BASE_ADDR      ),
    .C_M_AXI_BURST_LEN              ( AXI_BURST_LEN               ),
    .C_M_AXI_ID_WIDTH               ( AXI_ID_WIDTH                ),
    .C_M_AXI_ADDR_WIDTH             ( AXI_ADDR_WIDTH              ),
    .C_M_AXI_DATA_WIDTH             ( AXI_DATA_WIDTH              ))
U_M_AXI_0(
    .INIT_AXI_TXN                   ( INIT_AXI_TXN                ),
    .TXN_DONE                       ( TXN_DONE                    ),
    .ERROR                          ( ERROR                       ),
    .M_AXI_ACLK                     ( AXI_ACLK                    ),
    .M_AXI_ARESETN                  ( AXI_ARESETN                 ),
    .M_AXI_AWID                     ( AXI_AWID                    ),
    .M_AXI_AWADDR                   ( AXI_AWADDR                  ),
    .M_AXI_AWLEN                    ( AXI_AWLEN                   ),
    .M_AXI_AWSIZE                   ( AXI_AWSIZE                  ),
    .M_AXI_AWBURST                  ( AXI_AWBURST                 ),
    .M_AXI_AWLOCK                   ( AXI_AWLOCK                  ),
    .M_AXI_AWCACHE                  ( AXI_AWCACHE                 ),
    .M_AXI_AWPROT                   ( AXI_AWPROT                  ),
    .M_AXI_AWQOS                    ( AXI_AWQOS                   ),
    .M_AXI_AWUSER                   ( AXI_AWUSER                  ),
    .M_AXI_AWVALID                  ( AXI_AWVALID                 ),
    .M_AXI_AWREADY                  ( AXI_AWREADY                 ),
    .M_AXI_WDATA                    ( AXI_WDATA                   ),
    .M_AXI_WSTRB                    ( AXI_WSTRB                   ),
    .M_AXI_WLAST                    ( AXI_WLAST                   ),
    .M_AXI_WUSER                    ( AXI_WUSER                   ),
    .M_AXI_WVALID                   ( AXI_WVALID                  ),
    .M_AXI_WREADY                   ( AXI_WREADY                  ),
    .M_AXI_BID                      ( AXI_BID                     ),
    .M_AXI_BRESP                    ( AXI_BRESP                   ),
    .M_AXI_BUSER                    ( AXI_BUSER                   ),
    .M_AXI_BVALID                   ( AXI_BVALID                  ),
    .M_AXI_BREADY                   ( AXI_BREADY                  ),
    .M_AXI_ARID                     ( AXI_ARID                    ),
    .M_AXI_ARADDR                   ( AXI_ARADDR                  ),
    .M_AXI_ARLEN                    ( AXI_ARLEN                   ),
    .M_AXI_ARSIZE                   ( AXI_ARSIZE                  ),
    .M_AXI_ARBURST                  ( AXI_ARBURST                 ),
    .M_AXI_ARLOCK                   ( AXI_ARLOCK                  ),
    .M_AXI_ARCACHE                  ( AXI_ARCACHE                 ),
    .M_AXI_ARPROT                   ( AXI_ARPROT                  ),
    .M_AXI_ARQOS                    ( AXI_ARQOS                   ),
    .M_AXI_ARUSER                   ( AXI_ARUSER                  ),
    .M_AXI_ARVALID                  ( AXI_ARVALID                 ),
    .M_AXI_ARREADY                  ( AXI_ARREADY                 ),
    .M_AXI_RID                      ( AXI_RID                     ),
    .M_AXI_RDATA                    ( AXI_RDATA                   ),
    .M_AXI_RRESP                    ( AXI_RRESP                   ),
    .M_AXI_RLAST                    ( AXI_RLAST                   ),
    .M_AXI_RUSER                    ( AXI_RUSER                   ),
    .M_AXI_RVALID                   ( AXI_RVALID                  ),
    .M_AXI_RREADY                   ( AXI_RREADY                  )
);

S_AXI #(
    .C_S_AXI_ID_WIDTH               ( AXI_ID_WIDTH                ),
    .C_S_AXI_DATA_WIDTH             ( AXI_DATA_WIDTH              ),
    .C_S_AXI_ADDR_WIDTH             ( AXI_ADDR_WIDTH              ))
U_S_AXI_0(
    .S_AXI_ACLK                     ( AXI_ACLK                    ),
    .S_AXI_ARESETN                  ( AXI_ARESETN                 ),
    .S_AXI_AWID                     ( AXI_AWID                    ),
    .S_AXI_AWADDR                   ( AXI_AWADDR                  ),
    .S_AXI_AWLEN                    ( AXI_AWLEN                   ),
    .S_AXI_AWSIZE                   ( AXI_AWSIZE                  ),
    .S_AXI_AWBURST                  ( AXI_AWBURST                 ),
    .S_AXI_AWLOCK                   ( AXI_AWLOCK                  ),
    .S_AXI_AWCACHE                  ( AXI_AWCACHE                 ),
    .S_AXI_AWPROT                   ( AXI_AWPROT                  ),
    .S_AXI_AWQOS                    ( AXI_AWQOS                   ),
    .S_AXI_AWREGION                 ( AXI_AWREGION                ),
    .S_AXI_AWUSER                   ( AXI_AWUSER                  ),
    .S_AXI_AWVALID                  ( AXI_AWVALID                 ),
    .S_AXI_AWREADY                  ( AXI_AWREADY                 ),
    .S_AXI_WDATA                    ( AXI_WDATA                   ),
    .S_AXI_WSTRB                    ( AXI_WSTRB                   ),
    .S_AXI_WLAST                    ( AXI_WLAST                   ),
    .S_AXI_WUSER                    ( AXI_WUSER                   ),
    .S_AXI_WVALID                   ( AXI_WVALID                  ),
    .S_AXI_WREADY                   ( AXI_WREADY                  ),
    .S_AXI_BID                      ( AXI_BID                     ),
    .S_AXI_BRESP                    ( AXI_BRESP                   ),
    .S_AXI_BUSER                    ( AXI_BUSER                   ),
    .S_AXI_BVALID                   ( AXI_BVALID                  ),
    .S_AXI_BREADY                   ( AXI_BREADY                  ),
    .S_AXI_ARID                     ( AXI_ARID                    ),
    .S_AXI_ARADDR                   ( AXI_ARADDR                  ),
    .S_AXI_ARLEN                    ( AXI_ARLEN                   ),
    .S_AXI_ARSIZE                   ( AXI_ARSIZE                  ),
    .S_AXI_ARBURST                  ( AXI_ARBURST                 ),
    .S_AXI_ARLOCK                   ( AXI_ARLOCK                  ),
    .S_AXI_ARCACHE                  ( AXI_ARCACHE                 ),
    .S_AXI_ARPROT                   ( AXI_ARPROT                  ),
    .S_AXI_ARQOS                    ( AXI_ARQOS                   ),
    .S_AXI_ARREGION                 ( AXI_ARREGION                ),
    .S_AXI_ARUSER                   ( AXI_ARUSER                  ),
    .S_AXI_ARVALID                  ( AXI_ARVALID                 ),
    .S_AXI_ARREADY                  ( AXI_ARREADY                 ),
    .S_AXI_RID                      ( AXI_RID                     ),
    .S_AXI_RDATA                    ( AXI_RDATA                   ),
    .S_AXI_RRESP                    ( AXI_RRESP                   ),
    .S_AXI_RLAST                    ( AXI_RLAST                   ),
    .S_AXI_RUSER                    ( AXI_RUSER                   ),
    .S_AXI_RVALID                   ( AXI_RVALID                  ),
    .S_AXI_RREADY                   ( AXI_RREADY                  )
);





initial begin
    $dumpfile("axi_tb.vcd");
    $dumpvars;
end


endmodule

