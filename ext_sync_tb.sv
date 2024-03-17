`timescale 1ns/1ps

module ext_sync_tb;

    localparam CLOCK_PERIOD = 10; //clock in ns.
    localparam DATA_WIDTH = 32;

    logic clk;
    logic reset = 1;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    logic data;

    external_synchronizer #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .data_in(data),
        .data_out(data_out)
    );

    //wait 3 clock cycles before de-asserting reset.
    always begin 
        #(3*CLOCK_PERIOD);
        reset = 0;
    end

    //aways generate clock rising edge on 10s place.
    always begin
        clk = 1'b0;
        #(CLOCK_PERIOD/2);
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    initial begin
        data_in = $random;
        for (int i = 0; i<32; i++) begin
            data = data_in[i];
            #(CLOCK_PERIOD*2);
            if(data_out != data) begin
                $display("data_in[%0d] = %0h, data_out = %0h", i, data_in, data_out);
                $stop;
            end
        end
    end

endmodule