`timescale 1ns / 1ps

module tb_baud_rate_generator_with_offset;

    localparam SYS_CLK_FREQ = 125000000;    // 50 MHz system clock
    localparam BAUD_RATE = 115200;          // Target baud rate
    localparam ACC_WIDTH = 32;              // Accumulator width
    localparam PHASE_OFFSET_DEG = 180;      // Phase offset in degrees
    localparam CLOCKS_PER_BAUD = SYS_CLK_FREQ / BAUD_RATE;

    logic clk;
    logic reset;
    logic baud_tick;
    logic gen_clock;
    logic gen_clock_offset;

    baud_rate_generator_with_offset #(
        .SYS_CLK_FREQ(SYS_CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .ACC_WIDTH(ACC_WIDTH),
        .PHASE_OFFSET_DEG(PHASE_OFFSET_DEG)
    ) dut (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .baud_tick_offset(baud_tick_offset),
        .gen_clock(gen_clock),
        .gen_clock_offset(gen_clock_offset)
    );

    initial begin
        clk = 0;
        forever #(4) clk = ~clk; // Generate a 125 MHz clock (8 ns period)
    end

    initial begin
        reset = 1;
        #(16); // Wait for 40 ns
        reset = 0;

        for (int i = 0; i < SYS_CLK_FREQ; i++) begin
            @(posedge clk);
            if (baud_tick && (i==CLOCKS_PER_BAUD)) begin
                $display("Baud tick at %d clocks. Expected", i);
            end
            else if (baud_tick_offset && (i==CLOCKS_PER_BAUD)) begin
                $display("Baud tick with 180 degree phase offset at %d clocks. Expected", i);
            end
            else if (i==CLOCKS_PER_BAUD) begin
                $display("No baud tick at %d clocks", i);
            end
            else if (i==CLOCKS_PER_BAUD/2) begin
                $display("No baud tick with 180 degree phase offset at %d clocks", i);
            end
            else if (baud_tick) begin
                $display("Baud tick at %d clocks", i);
            end
            else if (baud_tick_offset) begin
                $display("Baud tick with 180 degree phase offset at %d clocks", i);
            end
        end

        #(2000000); // Run for a significant time to observe multiple baud ticks

        // End simulation
        //$finish;
    end

    // Optional: Add checks or measures to validate the phase offset effect

endmodule
