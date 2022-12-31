// +FHDR----------------------------------------------------------------------------
//                 Copyright (c) 2022
//                       ALL RIGHTS RESERVED
// ---------------------------------------------------------------------------------
// Filename      : s_axi.v
// Author        : Rongye
// Created On    : 2022-12-25 03:13
// Last Modified : 2022-12-30 20:13
// ---------------------------------------------------------------------------------
// Description   :
//
//
// -FHDR----------------------------------------------------------------------------
`include "easy_axi_para.v"

module S_AXI #
(
    parameter integer S_AXI_ID_WIDTH	= 1,
    parameter integer S_AXI_DATA_WIDTH	= 32,
    parameter integer S_AXI_ADDR_WIDTH	= 32

)
(
// Global 
    input                                   s_axi_aclk,
    input                                   s_axi_aresetn,
// AW channel
    input [S_AXI_ID_WIDTH-1 : 0]            s_axi_awid,
    input [S_AXI_ADDR_WIDTH-1 : 0]          s_axi_awaddr,
    input [`AXI_BURST_LEN_WIDTH-1 : 0]      s_axi_awlen,
    input [`AXI_BURST_SIZE_WIDTH-1 : 0]     s_axi_awsize,
    input [`AXI_BURST_TYPE_WIDTH-1 : 0]     s_axi_awburst,
    input                                   s_axi_awlock,
    input [`AXI_CACHE_WIDTH-1 : 0]          s_axi_awcache,
    input [`AXI_PROT_WIDTH-1 : 0]           s_axi_awprot,
    input [`AXI_QOS_WIDTH-1 : 0]            s_axi_awqos,
    input [`AXI_REGION_WIDTH-1 : 0]         s_axi_awregion,
    input                                   s_axi_awvalid,
    output                                  s_axi_awready,
// W channel
    input [S_AXI_DATA_WIDTH-1 : 0]          s_axi_wdata,
    input [(S_AXI_DATA_WIDTH/8)-1 : 0]      s_axi_wstrb,
    input                                   s_axi_wlast,
    input                                   s_axi_wvalid,
    output                                  s_axi_wready,
// B channel
    output [S_AXI_ID_WIDTH-1 : 0]           s_axi_bid,
    output [`AXI_RESP_WIDTH-1 : 0]          s_axi_bresp,
    output                                  s_axi_bvalid,
    input                                   s_axi_bready,
// AR channel
    input [S_AXI_ID_WIDTH-1 : 0]            s_axi_arid,
    input [S_AXI_ADDR_WIDTH-1 : 0]          s_axi_araddr,
    input [`AXI_BURST_LEN_WIDTH-1 : 0]      s_axi_arlen,
    input [`AXI_BURST_SIZE_WIDTH-1 : 0]     s_axi_arsize,
    input [`AXI_BURST_TYPE_WIDTH-1 : 0]     s_axi_arburst,
    input                                   s_axi_arlock,
    input [`AXI_CACHE_WIDTH-1 : 0]          s_axi_arcache,
    input [`AXI_PROT_WIDTH-1 : 0]           s_axi_arprot,
    input [`AXI_QOS_WIDTH-1 : 0]            s_axi_arqos,
    input [`AXI_REGION_WIDTH-1 : 0]         s_axi_arregion,
    input                                   s_axi_arvalid,
    output                                  s_axi_arready,
// R channel
    output [S_AXI_ID_WIDTH-1 : 0]           s_axi_rid,
    output [S_AXI_DATA_WIDTH-1 : 0]         s_axi_rdata,
    output [`AXI_RESP_WIDTH-1 : 0]          s_axi_rresp,
    output                                  s_axi_rlast,
    output                                  s_axi_rvalid,
    input                                   s_axi_rready
);

reg  [S_AXI_ADDR_WIDTH-1 : 0] 	 axi_awaddr;
reg                              axi_awready;
reg                              axi_wready;
reg  [`AXI_RESP_WIDTH-1 : 0] 	 axi_bresp;
reg                              axi_bvalid;
reg  [S_AXI_ADDR_WIDTH-1 : 0] 	 axi_araddr;
reg                              axi_arready;
reg  [S_AXI_DATA_WIDTH-1 : 0] 	 axi_rdata;
reg  [`AXI_RESP_WIDTH-1 : 0] 	 axi_rresp;
reg                              axi_rlast;
reg                              axi_rvalid;
wire                             aw_wrap_en;
wire                             ar_wrap_en;
wire [31:0]                      aw_wrap_size ;
wire [31:0]                      ar_wrap_size ;
reg                              burst_write_active;
reg                              burst_read_active;
reg  [7:0]                       write_index;
reg  [7:0]                       read_index;
reg  [`AXI_BURST_TYPE_WIDTH-1:0] axi_arburst;
reg  [`AXI_BURST_TYPE_WIDTH-1:0] axi_awburst;
reg  [`AXI_BURST_LEN_WIDTH-1:0]  axi_arlen;
reg  [`AXI_BURST_LEN_WIDTH-1:0]  axi_awlen;


localparam integer ADDR_LSB       = (S_AXI_DATA_WIDTH/32)+ 1;
localparam integer MEM_ADDR_WIDTH = 5;
localparam integer MEM_NUM        = 1;
localparam integer MEM_BYTE_NUM   = 64; // Maximum number of bytes that can be written

wire [MEM_ADDR_WIDTH:0]     mem_address;
reg  [S_AXI_DATA_WIDTH-1:0] mem_data_out[0 : MEM_NUM-1];

genvar mem_index;
genvar mem_byte_index;

assign s_axi_awready = axi_awready;
assign s_axi_wready  = axi_wready;
assign s_axi_bresp   = axi_bresp;
assign s_axi_bvalid  = axi_bvalid;
assign s_axi_arready = axi_arready;
assign s_axi_rdata   = axi_rdata;
assign s_axi_rresp   = axi_rresp;
assign s_axi_rlast   = axi_rlast;
assign s_axi_rvalid  = axi_rvalid;
assign s_axi_bid     = s_axi_awid;
assign s_axi_rid     = s_axi_arid;

assign aw_wrap_size  = (S_AXI_DATA_WIDTH/8 * (axi_awlen));
assign ar_wrap_size  = (S_AXI_DATA_WIDTH/8 * (axi_arlen));
assign aw_wrap_en    = ((axi_awaddr & aw_wrap_size) == aw_wrap_size)? 1'b1: 1'b0;
assign ar_wrap_en    = ((axi_araddr & ar_wrap_size) == ar_wrap_size)? 1'b1: 1'b0;

// start write transaction when assert awvalid
always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_awready        <= 1'b0;
        burst_write_active <= 1'b0;
    end
    else begin
        if (~axi_awready && s_axi_awvalid && ~burst_write_active && ~burst_read_active) begin
            axi_awready        <= 1'b1;
            burst_write_active <= 1'b1;
        end
        else if (s_axi_wlast && axi_wready) begin
            burst_write_active  <= 1'b0;
        end
        else begin
            axi_awready <= 1'b0;
        end
    end
end

//--------------------
// Write transaction
//--------------------

always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_awaddr  <= 0;
        write_index <= 0;
        axi_awburst <= 0;
        axi_awlen   <= 0;
    end
    else begin
        if (~axi_awready && s_axi_awvalid && ~burst_write_active) begin
            axi_awaddr  <= s_axi_awaddr;
            axi_awburst <= s_axi_awburst;
            axi_awlen   <= s_axi_awlen;
            write_index <= 0;
        end
        else if((write_index <= axi_awlen) && axi_wready && s_axi_wvalid) begin
            write_index <= write_index + 1;
            case (axi_awburst)
                2'b00: // fixed burst
                    begin
                        axi_awaddr <= axi_awaddr;
                    end
                2'b01: //incremental burst
                    begin
                        axi_awaddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_awaddr[ADDR_LSB-1:0]                  <= {ADDR_LSB{1'b0}};
                    end
                2'b10: //Wrapping burst
                    if (aw_wrap_en) begin
                        axi_awaddr <= (axi_awaddr - aw_wrap_size);
                    end
                    else begin
                        axi_awaddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_awaddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_awaddr[ADDR_LSB-1:0]                  <= {ADDR_LSB{1'b0}};
                    end
                default: 
                    begin
                        axi_awaddr <= axi_awaddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                    end
            endcase
        end
    end
end



always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_wready <= 1'b0;
    end
    else begin
        if (~axi_wready && s_axi_wvalid && burst_write_active) begin
            axi_wready <= 1'b1;
        end
        else if (s_axi_wlast && axi_wready) begin
            axi_wready <= 1'b0;
        end
    end
end

always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_bvalid <= 1'b0;
        axi_bresp  <= 2'b0;
    end
    else begin
        if (burst_write_active && axi_wready && s_axi_wvalid && ~axi_bvalid && s_axi_wlast ) begin
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b0; // OK
        end
        else begin
            if (s_axi_bready && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end
end

//--------------------
// Read transaction
//--------------------

always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_arready       <= 1'b0;
        burst_read_active <= 1'b0;
    end
    else begin
        if (~axi_arready && s_axi_arvalid && ~burst_write_active && ~burst_read_active) begin
            axi_arready       <= 1'b1;
            burst_read_active <= 1'b1;
        end
        else if (axi_rvalid && s_axi_rready && read_index == axi_arlen) begin
            burst_read_active  <= 1'b0;
        end
        else begin
            axi_arready <= 1'b0;
        end
    end
end


always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_araddr  <= 0;
        read_index  <= 0;
        axi_arburst <= 0;
        axi_arlen   <= 0;
        axi_rlast   <= 1'b0;
    end
    else begin
        if (~axi_arready && s_axi_arvalid && ~burst_read_active) begin
            axi_araddr  <= s_axi_araddr[S_AXI_ADDR_WIDTH - 1:0];
            axi_arburst <= s_axi_arburst;
            axi_arlen   <= s_axi_arlen;
            read_index  <= 0;
            axi_rlast   <= 1'b0;
        end
        else if((read_index <= axi_arlen) && axi_rvalid && s_axi_rready) begin
            read_index <= read_index + 1;
            axi_rlast  <= 1'b0;
            case (axi_arburst)
                2'b00: // fixed burst
                    begin
                        axi_araddr <= axi_araddr;
                    end
                2'b01: //incremental burst
                    begin
                        axi_araddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};
                    end
                2'b10: //Wrapping burst
                    if (ar_wrap_en) begin
                        axi_araddr <= (axi_araddr - ar_wrap_size);
                    end
                    else begin
                        axi_araddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] <= axi_araddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB] + 1;
                        axi_araddr[ADDR_LSB-1:0]  <= {ADDR_LSB{1'b0}};
                    end
                default: 
                    begin
                        axi_araddr <= axi_araddr[S_AXI_ADDR_WIDTH - 1:ADDR_LSB]+1;
                    end
            endcase
        end
        else if((read_index == axi_arlen) && ~axi_rlast && burst_read_active) begin
            axi_rlast <= 1'b1;
        end
        else if (s_axi_rready) begin
            axi_rlast <= 1'b0;
        end
    end
end


always @(posedge s_axi_aclk) begin
    if (s_axi_aresetn == 1'b0) begin
        axi_rvalid <= 0;
        axi_rresp  <= 0;
    end
    else begin
        if (burst_read_active && ~axi_rvalid) begin
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b0;
        end
        else if (axi_rvalid && s_axi_rready) begin
            axi_rvalid <= 1'b0;
        end
    end
end


// implement Block RAM(s)
generate
    if (MEM_NUM >= 1) begin
        assign mem_address = (burst_read_active  ? axi_araddr[ADDR_LSB+MEM_ADDR_WIDTH:ADDR_LSB] 
                           : (burst_write_active ? axi_awaddr[ADDR_LSB+MEM_ADDR_WIDTH:ADDR_LSB] 
                           : 0));
    end
endgenerate

generate
    for(mem_index=0; mem_index<= MEM_NUM-1; mem_index=mem_index+1) begin:BRAM_GEN
        wire mem_rden;
        wire mem_wren;

        assign mem_wren = axi_wready && s_axi_wvalid;
        assign mem_rden = burst_read_active; 

        for(mem_byte_index=0; mem_byte_index<= (S_AXI_DATA_WIDTH/8-1); mem_byte_index=mem_byte_index+1) begin:BYTE_BRAM_GEN
            wire [8-1:0] data_in ;
            wire [8-1:0] data_out;
            reg  [8-1:0] byte_ram [0 : MEM_BYTE_NUM-1]; 

            assign data_in  = s_axi_wdata[(mem_byte_index*8+7) -: 8];
            assign data_out = byte_ram[mem_address];

            always @(posedge s_axi_aclk) begin
                if (mem_wren && s_axi_wstrb[mem_byte_index]) begin
                    byte_ram[mem_address] <= data_in;
                end
            end
            always @(posedge s_axi_aclk) begin
                if (mem_rden) begin
                    mem_data_out[mem_index][(mem_byte_index*8+7) -: 8] <= data_out;
                end
            end
        end
    end
endgenerate

always @(mem_data_out[0]) begin // MEM_NUM == 1
    if (axi_rvalid) begin
        axi_rdata <= mem_data_out[0];
    end
    else begin
        axi_rdata <= 32'h00000000;
    end
end



endmodule

