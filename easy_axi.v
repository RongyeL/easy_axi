// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022 
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : easy_axi.v
// Author        : Rongye
// Created On    : 2022-12-27 03:57
// Last Modified : 2022-12-30 20:08
// ---------------------------------------------------------------------------------
// Description   : 
//
//
// -FHDR----------------------------------------------------------------------------
`include "easy_axi_para.v"

module EASY_AXI #(
    parameter TARGET_SLAVE_BASE_ADDR   = 32'h40000000, // target address
    parameter integer AXI_BURST_LEN    = 16, // Support 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths 
    parameter integer AXI_ID_WIDTH     = 1, 
    parameter integer AXI_ADDR_WIDTH   = 32,
    parameter integer AXI_DATA_WIDTH   = 32

)(
    input        clk,
    input        rst_n,
    input        txn_start, // transaction start
    input  [1:0] txn_type,  // transaction type
    output       txn_done   // transaction done
);

// global 
wire                                   axi_aclk;
wire                                   axi_aresetn;  // active low
// AW channel
wire [AXI_ID_WIDTH-1 : 0]              axi_awid;     // write transaction id
wire [AXI_ADDR_WIDTH-1 : 0]            axi_awaddr;   // write address
wire [`AXI_BURST_LEN_WIDTH-1 : 0]      axi_awlen;    // write transaction burst lengths
wire [`AXI_BURST_SIZE_WIDTH-1 : 0]     axi_awsize;   // write transaction burst size
wire [`AXI_BURST_TYPE_WIDTH-1 : 0]     axi_awburst;  // write transaction burst type
wire                                   axi_awlock;   // write transaction atomic type
wire [`AXI_CACHE_WIDTH-1 : 0]          axi_awcache;  // write transaction memory attribute
wire [`AXI_PROT_WIDTH-1 : 0]           axi_awprot;   // write transaction protection attribute
wire [`AXI_QOS_WIDTH-1 : 0]            axi_awqos;    // write transaction quality of service
wire [`AXI_REGION_WIDTH-1 : 0]         axi_awregion; // write transaction region
wire                                   axi_awvalid;  // write address channel valid
wire                                   axi_awready;  // write address channel ready
// W channel
wire [AXI_DATA_WIDTH-1 : 0]            axi_wdata;    // write data
wire [(AXI_DATA_WIDTH/8)-1 : 0]        axi_wstrb;    // write strobe, indicate which byte is valid
wire                                   axi_wlast;    // write last data indicate
wire                                   axi_wvalid;   // write data channel valid
wire                                   axi_wready;   // write data channel ready
// B channel
wire [AXI_ID_WIDTH-1 : 0]              axi_bid;      // write transaction id
wire [`AXI_RESP_WIDTH-1 : 0]           axi_bresp;    // write response
wire                                   axi_bvalid;   // write response channel valid
wire                                   axi_bready;   // write response channel ready
// AR channel 
wire [AXI_ID_WIDTH-1 : 0]              axi_arid;     // read transaction id
wire [AXI_ADDR_WIDTH-1 : 0]            axi_araddr;   // read address
wire [`AXI_BURST_LEN_WIDTH-1 : 0]      axi_arlen;    // read transaction burst length
wire [`AXI_BURST_SIZE_WIDTH-1 : 0]     axi_arsize;   // read transaction burst size
wire [`AXI_BURST_TYPE_WIDTH-1 : 0]     axi_arburst;  // read transaction burst type
wire                                   axi_arlock;   // read atomic type
wire [`AXI_CACHE_WIDTH-1 : 0]          axi_arcache;  // read transaction memory attribute
wire [`AXI_PROT_WIDTH-1 : 0]           axi_arprot;   // read transaction protection attribute
wire [`AXI_QOS_WIDTH-1 : 0]            axi_arqos;    // read transaction quality of service
wire [`AXI_REGION_WIDTH-1 : 0]         axi_arregion; // read transaction region
wire                                   axi_arvalid;  // read address channel valid
wire                                   axi_arready;  // read address channel ready
// R channel
wire [AXI_ID_WIDTH-1 : 0]              axi_rid;      // read transaction id
wire [AXI_DATA_WIDTH-1 : 0]            axi_rdata;    // read data
wire [`AXI_RESP_WIDTH-1 : 0]           axi_rresp;    // read transaction response
wire                                   axi_rlast;    // read last data indicate
wire                                   axi_rvalid;   // read data channel valid
wire                                   axi_rready;   // read data channel read

assign axi_aclk    = clk;
assign axi_aresetn = rst_n;


M_AXI #(
    .M_TARGET_SLAVE_BASE_ADDR       ( TARGET_SLAVE_BASE_ADDR      ),
    .M_AXI_BURST_LEN                ( AXI_BURST_LEN               ),
    .M_AXI_ID_WIDTH                 ( AXI_ID_WIDTH                ),
    .M_AXI_ADDR_WIDTH               ( AXI_ADDR_WIDTH              ),
    .M_AXI_DATA_WIDTH               ( AXI_DATA_WIDTH              ))
U_M_AXI_0(
    .txn_start                      ( txn_start                   ),
    .txn_type                       ( txn_type                    ),
    .txn_done                       ( txn_done                    ),
    .m_axi_aclk                     ( axi_aclk                    ),
    .m_axi_aresetn                  ( axi_aresetn                 ),
    .m_axi_awid                     ( axi_awid                    ),
    .m_axi_awaddr                   ( axi_awaddr                  ),
    .m_axi_awlen                    ( axi_awlen                   ),
    .m_axi_awsize                   ( axi_awsize                  ),
    .m_axi_awburst                  ( axi_awburst                 ),
    .m_axi_awlock                   ( axi_awlock                  ),
    .m_axi_awcache                  ( axi_awcache                 ),
    .m_axi_awprot                   ( axi_awprot                  ),
    .m_axi_awqos                    ( axi_awqos                   ),
    .m_axi_awregion                 ( axi_awregion                ),
    .m_axi_awvalid                  ( axi_awvalid                 ),
    .m_axi_awready                  ( axi_awready                 ),
    .m_axi_wdata                    ( axi_wdata                   ),
    .m_axi_wstrb                    ( axi_wstrb                   ),
    .m_axi_wlast                    ( axi_wlast                   ),
    .m_axi_wvalid                   ( axi_wvalid                  ),
    .m_axi_wready                   ( axi_wready                  ),
    .m_axi_bid                      ( axi_bid                     ),
    .m_axi_bresp                    ( axi_bresp                   ),
    .m_axi_bvalid                   ( axi_bvalid                  ),
    .m_axi_bready                   ( axi_bready                  ),
    .m_axi_arid                     ( axi_arid                    ),
    .m_axi_araddr                   ( axi_araddr                  ),
    .m_axi_arlen                    ( axi_arlen                   ),
    .m_axi_arsize                   ( axi_arsize                  ),
    .m_axi_arburst                  ( axi_arburst                 ),
    .m_axi_arlock                   ( axi_arlock                  ),
    .m_axi_arcache                  ( axi_arcache                 ),
    .m_axi_arprot                   ( axi_arprot                  ),
    .m_axi_arqos                    ( axi_arqos                   ),
    .m_axi_arregion                 ( axi_arregion                ),
    .m_axi_arvalid                  ( axi_arvalid                 ),
    .m_axi_arready                  ( axi_arready                 ),
    .m_axi_rid                      ( axi_rid                     ),
    .m_axi_rdata                    ( axi_rdata                   ),
    .m_axi_rresp                    ( axi_rresp                   ),
    .m_axi_rlast                    ( axi_rlast                   ),
    .m_axi_rvalid                   ( axi_rvalid                  ),
    .m_axi_rready                   ( axi_rready                  )
);



S_AXI #(
    .S_AXI_ID_WIDTH                 ( AXI_ID_WIDTH                ),
    .S_AXI_DATA_WIDTH               ( AXI_DATA_WIDTH              ),
    .S_AXI_ADDR_WIDTH               ( AXI_ADDR_WIDTH              ))
U_S_AXI_0(
    .s_axi_aclk                     ( axi_aclk                    ),
    .s_axi_aresetn                  ( axi_aresetn                 ),
    .s_axi_awid                     ( axi_awid                    ),
    .s_axi_awaddr                   ( axi_awaddr                  ),
    .s_axi_awlen                    ( axi_awlen                   ),
    .s_axi_awsize                   ( axi_awsize                  ),
    .s_axi_awburst                  ( axi_awburst                 ),
    .s_axi_awlock                   ( axi_awlock                  ),
    .s_axi_awcache                  ( axi_awcache                 ),
    .s_axi_awprot                   ( axi_awprot                  ),
    .s_axi_awqos                    ( axi_awqos                   ),
    .s_axi_awregion                 ( axi_awregion                ),
    .s_axi_awvalid                  ( axi_awvalid                 ),
    .s_axi_awready                  ( axi_awready                 ),
    .s_axi_wdata                    ( axi_wdata                   ),
    .s_axi_wstrb                    ( axi_wstrb                   ),
    .s_axi_wlast                    ( axi_wlast                   ),
    .s_axi_wvalid                   ( axi_wvalid                  ),
    .s_axi_wready                   ( axi_wready                  ),
    .s_axi_bid                      ( axi_bid                     ),
    .s_axi_bresp                    ( axi_bresp                   ),
    .s_axi_bvalid                   ( axi_bvalid                  ),
    .s_axi_bready                   ( axi_bready                  ),
    .s_axi_arid                     ( axi_arid                    ),
    .s_axi_araddr                   ( axi_araddr                  ),
    .s_axi_arlen                    ( axi_arlen                   ),
    .s_axi_arsize                   ( axi_arsize                  ),
    .s_axi_arburst                  ( axi_arburst                 ),
    .s_axi_arlock                   ( axi_arlock                  ),
    .s_axi_arcache                  ( axi_arcache                 ),
    .s_axi_arprot                   ( axi_arprot                  ),
    .s_axi_arqos                    ( axi_arqos                   ),
    .s_axi_arregion                 ( axi_arregion                ),
    .s_axi_arvalid                  ( axi_arvalid                 ),
    .s_axi_arready                  ( axi_arready                 ),
    .s_axi_rid                      ( axi_rid                     ),
    .s_axi_rdata                    ( axi_rdata                   ),
    .s_axi_rresp                    ( axi_rresp                   ),
    .s_axi_rlast                    ( axi_rlast                   ),
    .s_axi_rvalid                   ( axi_rvalid                  ),
    .s_axi_rready                   ( axi_rready                  )
);



endmodule


