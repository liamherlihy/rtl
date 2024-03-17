//`timescale 1ns / 1ps

module baud_rate_generator_with_offset #(
    parameter SYS_CLK_FREQ = 125000000,     // System clock frequency in Hz
    parameter BAUD_RATE = 115200,           // Desired baud rate
    parameter ACC_WIDTH = 32,               // Width of the phase accumulator
    parameter PHASE_OFFSET_DEG = 180        // Phase offset in degrees
)(
    input wire clk,                        // System clock input
    input wire reset,                      // Asynchronous reset
    output logic baud_tick,                 // Baud rate tick output
    output logic baud_tick_offset,             // Baud rate tick output with 180 degree phase offset
    output logic gen_clock,                 // Generated clock
    output logic gen_clock_offset              // Generated clock 180deg phase shift
);
    localparam longint PHASE_INC = (BAUD_RATE * (2**ACC_WIDTH)) / SYS_CLK_FREQ;
    localparam longint PHASE_OFFSET = ((2**ACC_WIDTH)/(360/PHASE_OFFSET_DEG));

    logic [ACC_WIDTH-1:0] phase_accumulator;
    logic [1:0] test;
    logic phase_flip;

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize the phase accumulator with the phase offset
            phase_accumulator <= 0;
            test <= 0;
            phase_flip <= 0;
        end 
        else begin
            phase_accumulator <= phase_accumulator + PHASE_INC;
            test[0] <= phase_accumulator [31];
            test[1] <= test[0] ^ phase_accumulator[31];        
        end
    end

    always_comb begin
        baud_tick = &test;
        baud_tick_offset = test[1]&(!test[0]);
        gen_clock  = test[0];
        gen_clock_offset = !test[0];
    end
    
endmodule
