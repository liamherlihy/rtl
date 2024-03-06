module uart_ip #(
    parameter UART_SIZE = 8,
    parameter BAUD_RATE = 115200,
    parameter SYS_CLK_FREQ = 125000000,
    parameter SAMPLE_OFFSET = 180,
    parameter PARITY_ENABLE = 0,                //active high
    parameter PARITY_TYPE = 0,                  //0 for odd, 1 for even
    parameter CRC_ENABLE = 0
)(
    input logic clk,
    input logic reset,
    input logic RX,
    output logic TX,
    output logic RTS,
    input logic CTS
);

    logic baud_tick;
    logic phase_accum_reset;
    logic [UART_SIZE-1:0] rx_data;

    uart_rx #(
        .UART_SIZE(UART_SIZE)
    ) uart_rx (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),                  //sample time pulse generation.
        .phase_accum_reset(phase_accum_reset),  //resets the phase acumulator.
        .rx_data(rx_data),
        .parity_enable(PARITY_ENABLE),
        .parity_type(PARITY_TYPE),              // 0 = odd, 1 = even
        //.crc_error(),
        //.stop_error(),
        .RX(rx)
        );

    baud_rate_generator_with_offset #(
        .SYS_CLK_FREQ(SYS_CLK_FREQ),            // System clock frequency in Hz
        .BAUD_RATE(BAUD_RATE),                  // Desired baud rate
        .PHASE_OFFSET_DEG(SAMPLE_OFFSET)        // Phase offset in degrees
    ) baud_gen (
        .clk(clk),                              // System clock input
        .reset(resest||phase_accum_reset),      // Asynchronous reset
        .baud_tick_offset(baud_tick),           // Baud rate tick output with 180 degree phase offset
        .gen_clock,                             // Generated clock
        .gen_clock_offset                       // Generated clock 180deg phase shift
    );
    
endmodule