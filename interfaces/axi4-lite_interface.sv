interface axi4_lite #(
    parameter DATA_WIDTH = 32
    ) (
    input logic aclk, 
    input logic aresetn
    );

    localparam ADDR_WIDTH = (DATA_WIDTH == 32) ? 32 : 64; //data can be 32 or 64 bits only.
    localparam STRB_WIDTH = DATA_WIDTH / 8;

    //write address channel signals
    logic [ADDR_WIDTH-1:0] AWADDR; 
    logic AWVALID;                  
    logic [2:0] AWPROT; //?
    logic AWREADY;                 
    //wirte data channel signals
    logic [DATA_WIDTH-1:0] WDATA;
    logic [STRB_WIDTH-1:0] WSTRB;
    logic WVALID;
    logic WREADY;
    //write response channel signals
    logic [1:0] BRESP;
    logic BVALID;
    logic BREADY;
    //read address channel signals
    logic [ADDR_WIDTH-1:0] ARADDR;
    logic ARVALID;
    logic [2:0] ARPROT;
    logic ARREADY;
    //read data channel signals
    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0] RRESP;
    logic RVALID;
    logic RREADY;

    modport master(
        output AWADDR,
        output AWVALID,
        output AWPROT,
        input AWREADY,
        output WDATA,
        output WSTRB,
        output WVALID,
        input WREADY,
        input BRESP,
        input BVALID,
        output BREADY,
        output ARADDR,
        output ARVALID,
        output ARPROT,
        input ARREADY,
        input RDATA,
        input RRESP,
        input RVALID,
        output RREADY,
        input aclk,
        input aresetn
    );

    modport slave(
        input AWADDR,
        input AWVALID,
        input AWPROT,
        output AWREADY,
        input WDATA,
        input WSTRB,
        input WVALID,
        output WREADY,
        output BRESP,
        output BVALID,
        input BREADY,
        input ARADDR,
        input ARVALID,
        input ARPROT,
        output ARREADY,
        output RDATA,
        output RRESP,
        output RVALID,
        input RREADY,
        input aclk,
        input aresetn
    );

endinterface
