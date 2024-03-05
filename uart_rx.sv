`timescale 1ns/1ps

module uart_rx #(
    parameter UART_SIZE = 8
    )(
    input logic clk,
    input logic reset,
    input logic baud_tick, //sample time pulse generation.
    output logic phase_accum_reset, //resets the phase acumulator.
    output logic [UART_SIZE-1:0] rx_data,
    input logic parity_enable,
    input logic parity_type, // 0 = odd, 1 = even
    output logic crc_error,
    output logic stop_error,
    output logic CTS,
    input logic RTS,
    input logic RX
    );

    typedef enum {IDLE, START, DATA, CRC, STOP} state;

    logic [UART_SIZE-1:0] data_i_buffer; //stores the received data
    logic [$clog2(UART_SIZE):0] data_i_count; //counts the number of bits received
    logic parity_bit; //stores the parity bit

    state current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            data_i_buffer <= 0;
            rx_data <= 0;
            data_i_count <= 0;
            next_state <= IDLE;
            phase_accum_reset <= 1;
        end
        else begin
            case (current_state)
                IDLE: begin
                    if (!RX) begin
                        phase_accum_reset <= 0;
                        next_state <= START;
                    end
                    else begin
                        phase_accum_reset <= 1;
                        next_state <= IDLE; 
                    end
                end
                START: begin
                    if (!RX && baud_tick) begin
                        next_state <= DATA;
                    end
                    else if (RX && baud_tick) begin
                        next_state <= IDLE;
                    end
                end
                DATA: begin
                    if (data_i_count < UART_SIZE) begin
                        if (baud_tick) begin
                            data_i_buffer <= {RX,data_i_buffer[UART_SIZE-1:1]};
                            data_i_count <= data_i_count + 1;
                        end
                    end
                    else begin
                        //if parity is enabled, smaple an extra bit
                        if (parity_enable) begin
                            if (data_i_count < UART_SIZE + 1) begin
                                if (baud_tick) begin
                                    parity_bit <= RX;
                                    data_i_count <= data_i_count + 1;
                                    next_state <= CRC;
                                end
                            end
                        end                          
                        else begin
                            next_state <= STOP;
                        end
                    end
                end              
                CRC: begin
                    //check the parity
                    if (!parity_type) begin
                        //odd
                        crc_error <= (^data_i_buffer ^ parity_bit);
                    end
                    else begin
                        //even
                        crc_error <= (^data_i_buffer & parity_bit);
                    end
                    data_i_count <= 0;
                    next_state <= STOP;
                end
                STOP: begin
                    //sample stop bit and verify it's high.
                    if (baud_tick) begin
                        if (RX) begin
                            rx_data <= data_i_buffer;
                            data_i_buffer <= 0;
                            data_i_count <= 0;
                            stop_error <= 0;
                            phase_accum_reset <= 1;
                            next_state <= IDLE; 
                        end
                        else begin
                            rx_data <= 0;
                            data_i_buffer <= 0;
                            data_i_count <= 0;
                            stop_error <= 1;
                            phase_accum_reset <= 1;
                            next_state <= IDLE;

                        end
                    end
                end
                default: next_state <= IDLE; 
            endcase
        end
    end

    always_ff @(posedge clk) begin
        current_state <= next_state;
    end
        
endmodule 