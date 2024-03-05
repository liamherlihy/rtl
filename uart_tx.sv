`timescale 1ns/1ps

module uart_rx #(
    parameter UART_SIZE = 8
    )(
    input logic clk,
    input logic reset,
    output logic [7:0] data_o,
    input logic [19:0] baud_rate,
    input logic crc_enable,
    input logic [3:0] crc_type,

    input logic CTS,
    output logic RTS,
    output logic TX,
    input logic RX
    );

    typedef enum {IDLE, START, DATA, STOP, CRC } state;
    logic [UART_SIZE-1:0] data_o_buffer;
    logic [$clog2(UART_SIZE)-1:0] data_i_count, data_o_count;

    state current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            data_o_buffer <= 8'h00;
            next_state <= IDLE;
        end
    end

    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    always_comb begin 
        
    end
        
endmodule 