`timescale 1ns/1ps
`include "G:/Engineering_work/FPGA/rtl/interfaces/axi4-lite_interface.sv"

module tb_axi4_lite_memory;

    localparam DATA_WIDTH = 32;

    logic clk = 0;
    logic rst_n;

    // Generate Clock
    always #5 clk = !clk; // 100MHz clock

    //instantiate the AXI4-Lite interface
    axi4_lite #(.DATA_WIDTH(DATA_WIDTH)) axi_if(clk, rst_n);    
    
    //instantiate the memory IP (DUT)
    axi4_lite_mem axi_mem (.axi4_s(axi_if));

//------------------------------------------------
//INTERNAL FUNCTIONS
//------------------------------------------------

    task reset();
        $display("resetting signals and cores at time: %0t", $time);
        rst_n = 0;
        axi_if.awaddr = 0;	
        axi_if.awvalid = 0;	
        axi_if.awprot = 0;	 
        axi_if.wdata = 0;  
        axi_if.wstrb = 0;   
        axi_if.wvalid = 0;  
        axi_if.bready = 0;  
        axi_if.araddr = 0;  
        axi_if.arvalid = 0; 
        axi_if.arprot = 0;  
        axi_if.rready = 0; 
        #20;   // Hold reset for a bit
        rst_n = 1;
        $display("reset deasserted at time: %0t", $time);
        #100;  // Wait 100 ns for global reset to finish
    endtask


    task write_data (input logic [DATA_WIDTH-1:0]addr, input logic [DATA_WIDTH-1:0]data);
        $display("writing data at time: %0t", $time);
        axi_if.awaddr = addr;
        axi_if.awvalid = 1;
        axi_if.wdata = data;
        axi_if.wvalid = 1;
        @(posedge clk);
        
    endtask
    
    task clear_write();
        $display("clearing write signals at time: %0t", $time);
        axi_if.awaddr = 0;
        axi_if.awvalid = 0;
        axi_if.wdata = 0;
        axi_if.wvalid = 0;
        @(posedge clk);
    endtask

    wire [DATA_WIDTH-1:0] read_data_reg;
    //task read_data (input logic [DATA_WIDTH-1:0]addr, output [DATA_WIDTH-1:0] read_data_reg);
    task read_data (input logic [DATA_WIDTH-1:0]addr);
        //$display("reading data from %d at time: %0t",addr, $time);
        axi_if.araddr = addr;
        axi_if.arvalid = 1;
        axi_if.rready = 1;
        //$display("read: %h, expected: %h at time %t", read_data_reg, axi_mem.memory[addr], $time);
        @(posedge clk);
        //$display("read: %h, expected: %h at time %t", read_data_reg, axi_mem.memory[addr], $time);
    endtask
    
    task clear_read();
        //$display("clearing write signals at time: %0t", $time);
        axi_if.araddr = 0;
        axi_if.arvalid = 0;
        axi_if.rready = 0;
        @(posedge clk);
    endtask
    
    /*
    always @(posedge clk) begin
        if(axi_if.rvalid)
            read_data_reg = axi_if.rdata;
        else
            read_data_reg = 0;  
    end
    */
    
    always @(posedge clk) begin
        if(axi_if.rvalid)
            $display("read back %h at time %t", axi_if.rdata, $time);        
    end  
    
    assign read_data_reg = axi_if.rvalid ? axi_if.rdata : 32'h0000_0000;
    
    initial begin
        //initilize memeory
        reset(); @(posedge clk);
        //------------------------------------------------
        //WRITE TESTING
        //------------------------------------------------
        //write data with breaks inbetween
        write_data(32'h0000_0001, 32'h5555_5555);
        clear_write();
        write_data(32'h0000_0002, 32'h5555_5555);
        clear_write();
        write_data(32'h0000_0003, 32'h5555_5555);
        clear_write();
        
        //clear our data
        reset(); @(posedge clk);
        
        //test back to back writes with no breaks
        write_data(32'h0000_0001, 32'hAAAA_AAAA);
        write_data(32'h0000_0002, 32'h5555_5555);
        write_data(32'h0000_0003, 32'hF0F0_F0F0);
        clear_write();
        
        //------------------------------------------------
        //READ TESTING
        //------------------------------------------------
        $display("------------------------------------------------");
        $display("staggered reads");
        $display("------------------------------------------------");
        //read_data(32'h0000_0000, read_data_reg);
        read_data(32'h0000_0000);
        clear_read();
        //read_data(32'h0000_0001, read_data_reg);
        read_data(32'h0000_0001);
        clear_read();
        //read_data(32'h0000_0002, read_data_reg);
        read_data(32'h0000_0002);
        clear_read();
        //read_data(32'h0000_0003, read_data_reg);
        read_data(32'h0000_0003);
        clear_read();
        
        @(posedge clk); @(posedge clk);
        
        $display("------------------------------------------------");
        $display("back-to-back reads");
        $display("------------------------------------------------");
        //read_data(32'h0000_0000, read_data_reg);
        //read_data(32'h0000_0001, read_data_reg);
        //read_data(32'h0000_0002, read_data_reg);
        //read_data(32'h0000_0003, read_data_reg);
        read_data(32'h0000_0000);
        read_data(32'h0000_0001);
        read_data(32'h0000_0002);
        read_data(32'h0000_0003);
        clear_read();
        
        #1000;
    end

endmodule
