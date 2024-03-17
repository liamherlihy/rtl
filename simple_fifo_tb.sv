`timescale 1ns/1ps

module simple_fifo_tb;

    localparam DATA_WIDTH = 32;
    localparam DEPTH = 16;
    
    logic clk = 0;
    logic reset = 1;
    logic [DATA_WIDTH-1:0]data_in = 0;
    logic [DATA_WIDTH-1:0]data_out = 0;
    logic wr_en = 0;
    logic rd_en = 0;
    logic empty;
    logic full;
    logic error_checking = 0;
    
    always #(10) clk = ~clk;
    
    simple_fifo  #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) simple_fifi_0 (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .empty(empty),
        .full(full)
    );
    
    logic [DATA_WIDTH-1:0]test_data_in [DEPTH-1:0] = '{default:0};
    logic [DATA_WIDTH-1:0]test_data_out [DEPTH-1:0] = '{default:0};
    logic [$clog2(DEPTH)-1:0]error_counter = 0;
    
    task fill_fifo();
         for (int i = 0; i<DEPTH; i++) begin
            wr_en = 1;
            data_in = test_data_in[i];
            @(posedge clk);
        end
        wr_en = 0;
        @(posedge clk);
    endtask
    
    task empty_fifo();
        for (int i = 0; i<DEPTH; i++) begin
            if(!empty)
                rd_en = 1;
            else
                break;
            @(posedge clk);
            test_data_out[i] = data_out;
        end
        rd_en = 0;
        @(posedge clk);
    endtask 
    
    
    initial begin
        #20
        reset = 0;
        #20
        //generate random data for test_data_in
        for (int i = 0; i<DEPTH; i++) begin
            test_data_in[i] = $random;
        end
        #20;
        @(posedge clk);
        fill_fifo();
        //write data to fifo
        /*for (int i = 0; i<DEPTH; i++) begin
            wr_en = 1;
            data_in = test_data_in[i];
            @(posedge clk);
        end
        wr_en = 0;
        @(posedge clk);
        */
        empty_fifo();
        /*
        //read data from fifo
        for (int i = 0; i<DEPTH; i++) begin
            rd_en = 1;
            @(posedge clk);
            test_data_out[i] = data_out;
        end
        rd_en = 0;
        @(posedge clk);
        */
        
        for (int i = 0; i<DEPTH; i++) begin
            error_checking = 1;
            if (test_data_in[i] != test_data_out[i]) begin
                $display("ERROR: at index %0d. input %0h, but output is %0h.\n", i, test_data_in[i],test_data_out[i]);
                error_counter = error_counter + 1;
                 @(posedge clk);
            end
        end
        @(posedge  clk);
        error_checking = 0;
        $display("Test complete. %0d errors found.", error_counter);
    end 

endmodule