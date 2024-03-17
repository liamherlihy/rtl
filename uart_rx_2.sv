module uart_rx #(
    parameter UART_SIZE = 8
)(
    input logic clk,
    input logic reset,
    input logic baud_tick, //sample time pulse generation.
    output logic phase_accum_reset, //resets the phase acumulator.
    output logic [UART_SIZE-1:0] rx_data,
    input logic parity_enable,
    input logic parity_type, //0 = odd, 1 = even
    output logic crc_error,
    output logic stop_error,
    input logic RX,
    output logic valid
);

typedef enum integer {IDLE, START, DATA, CRC, STOP} FSM_STATE;
FSM_STATE state = IDLE; //initilize state.
FSM_STATE next_state;

logic [UART_SIZE-1:0] data_i_buffer; //stores the received data
logic [$clog2(UART_SIZE):0] data_i_count; //counts the number of bits received
logic parity_bit; //stores the parity bit



//clocked state change & data sampling
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_i_count <= 0;
        rx_data <= 0;
    end
    else
        state <= next_state;
        if(baud_tick && (state == DATA)) begin
            data_i_count <= data_i_count + 1;
            rx_data <= {RX,rx_data[7:1]}; //data comes in LSB first, so we shift right.
        end   
end

always_comb begin
    unique case (state)

        IDLE: begin
            
        end
        START: begin

        end
        DATA: begin

        end
        CRC: begin

        end
        STOP: begin

        end
    endcase
end

endmodule