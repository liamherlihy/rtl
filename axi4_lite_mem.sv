`include "G:/Engineering_work/FPGA/rtl/interfaces/axi4-lite_interface.sv"
module axi4_lite_mem #(
    parameter DATA_WIDTH = 32
)(
    //input logic clk,
    //input logic reset,
    axi4_lite.slave axi4_s
);
    wire clk = axi4_s.aclk;
    wire reset = ~axi4_s.aresetn;
    
    logic [DATA_WIDTH-1:0] memory [63:0] = '{default:0};
    logic [DATA_WIDTH-1:0] csr = '{default:0};
    logic [DATA_WIDTH-1:0] write_data_buffer = 0;
    logic [DATA_WIDTH-1:0] write_addr_buff = 0;
    logic [DATA_WIDTH-1:0] read_data_buffer = 0;
    logic [DATA_WIDTH-1:0] read_data_buffer_out=0;
    logic [DATA_WIDTH-1:0] read_addr_buff = 0;   

    //when we reset, we want to set the first memory location to 0xdeadbeef for debug
    always_ff @(posedge clk) begin
        if (reset) begin
            write_addr_buff <= 0;
            write_data_buffer <= 0;
            read_addr_buff <= 0;
            read_data_buffer <= 0;    
        end
        else begin
            write_addr_buff <= axi4_s.awaddr;
            write_data_buffer <= axi4_s.wdata;
            read_addr_buff <= axi4_s.araddr;
            read_data_buffer <= memory[axi4_s.araddr];
        end      
    end

    //pipeline the write data so we can do simultaneous read and write (OPTIONAL IF NEEDED)
            
    //--------------------------------------------------------------------------------
    //WRITE DATA HANDLING
    //--------------------------------------------------------------------------------      
    //write address handling
    always_ff @(posedge clk) begin
        if(reset)
            memory[0] <= 32'hdeadbeef; //bit 0 is reset.
        else if(axi4_s.awready && axi4_s.wready && ~reset) begin
            memory[write_addr_buff] <= write_data_buffer;
        end
    end

    always_comb begin
        if(axi4_s.awvalid && ~reset)
            axi4_s.awready = 1;
        else 
            axi4_s.awready = 0;
    end

    always_comb begin
        if(axi4_s.wvalid && ~reset) begin
            axi4_s.wready = 1;
        end
        else begin 
            axi4_s.wready = 0;
        end
    end

    //--------------------------------------------------------------------------------
    //READ DATA HANDLING
    //--------------------------------------------------------------------------------
    //read address handing
    always_ff @(posedge clk) begin
        if(reset) begin
            axi4_s.rdata <= 0;
            axi4_s.rvalid <= 0;
            //read_data_buffer_out <= 0;
        end
        else if(axi4_s.arready) begin
            axi4_s.rdata <= read_data_buffer;
            //read_data_buffer_out <= read_data_buffer;
            axi4_s.rvalid <= 1;
        end
        else begin
            axi4_s.rvalid <= 0;
            //read_data_buffer_out <= 0;
        end
    end

    //read address valid ready handling
    always_comb begin
        if(axi4_s.arvalid && ~reset)
            axi4_s.arready = 1;
        else 
            axi4_s.arready = 0;
    end
/*
    //read data valid ready handling
     always_comb begin
        if(axi4_s.rvalid && ~reset)
            axi4_s.rready <= 1;
        else 
            axi4_s.rready <= 0;
    end
*/
    //--------------------------------------------------------------------------------
    //DEFAULT VALUES
    //--------------------------------------------------------------------------------

    //assign axi4_s.awprot = 3'b000; //write protection non-protected, secure,
    assign axi4_s.bvalid = axi4_s.awready && axi4_s.wready;
    assign axi4_s.bresp = 2'b00; //write response OK
    assign axi4_s.rresp = 2'b00; //read response OK
    //assign axi4_s.rvalid = axi4_s.rready;
    //assign axi4_s.rdata = read_data_buffer;

endmodule