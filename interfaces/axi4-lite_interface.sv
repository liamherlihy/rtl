interface axi4_lite #(
    parameter DATA_WIDTH = 32
    ) (
    input logic aclk,       //clock
    input logic aresetn     //reset, active low
    );

    localparam ADDR_WIDTH = (DATA_WIDTH == 32) ? 32 : 64; //data can be 32 or 64 bits only.
    localparam STRB_WIDTH = DATA_WIDTH / 8; //byte strobe width 

    //write address channel signals - done
    logic [ADDR_WIDTH-1:0] awaddr;  //write address
    logic awvalid;                  //address write valid
    //logic [2:0] awprot;             //write protection, 3 bit wide
    logic awready;                  //address write ready
    //wirte data channel signals
    logic [DATA_WIDTH-1:0] wdata;   //write data
    logic [STRB_WIDTH-1:0] wstrb;   //write strobe. Not used in axi4-lite
    logic wvalid;                   //write data valid
    logic wready;                   //write data ready
    //write response channel signals
    logic [1:0] bresp;              //write response
    logic bvalid;                   //write response valid
    logic bready;                   //write response ready
    //read address channel signals
    logic [ADDR_WIDTH-1:0] araddr;  //read address
    logic arvalid;                  //read address valid
    //logic [2:0] arprot;             //read protection, 3 bit wide. Defaulted to 0 for axi4-lite
    logic arready;                  //read address ready
    //read data channel signals
    logic [DATA_WIDTH-1:0] rdata;   //read data
    logic [1:0] rresp;              //read response
    logic rvalid;                   //read data valid
    logic rready;                   //read data ready

    modport master(
        output awaddr, awvalid, wdata, wstrb, wvalid, bready, araddr, arvalid, rready,
        input awready, wready, bresp, bvalid, arready, rdata, rresp, rvalid, aclk, aresetn
        //output awprot, arprot
    );

    modport slave(
        input awaddr, awvalid, wdata, wstrb, wvalid, bready, araddr, arvalid, rready, aclk, aresetn,
        output awready, wready, bresp, bvalid, arready, rdata, rresp, rvalid
        //input awprot, arprot
        
    );

endinterface
