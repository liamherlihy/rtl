`include "G:/Engineering_work/FPGA/rtl/interfaces/axi4-lite_interface.sv"

module uart_ip #(
    parameter UART_SIZE = 8,
    parameter BAUD_RATE = 115200,
    parameter SYS_CLK_FREQ = 125000000,
    parameter SAMPLE_OFFSET = 180,
    parameter PARITY_ENABLE = 0,                //active high
    parameter PARITY_TYPE = 0,                  //0 for odd, 1 for even
    parameter CRC_ENABLE = 0,
    parameter TX_DEPTH = 32,
    parameter RX_DEPTH = 32
)(
    input wire clk,
    input wire reset,
    input wire RX,
    output wire TX,
    output wire RTS,
    input wire CTS,
    //TODO: add axi4-lite interface here.
    axi4_lite.slave axi4_s
);

    wire baud_tick;
    wire phase_accum_reset;
    wire [UART_SIZE-1:0] rx_data;
    wire gen_clock;
    wire gen_clock_offset;
    wire stop_error;
    //wire done;
    wire rx_fifo_wr_en;
    wire rx_fifo_rd_en;
    wire rx_fifo_empty;
    wire rx_fifo_full;
    wire rx_fifo_error;
    wire crc_error;
    /*
    wire tx_fifo_wr_en;
    wire tx_fifo_rd_en;
    wire tx_fifo_empty;
    wire tx_fifo_full;
    wire tx_fifo_error;
    */

    /*
    //TODO: Implement TX side
    simple_fifo #(
    .DATA_WIDTH(UART_SIZE),
    .DEPTH(TX_DEPTH)
    ) tx_fifo (
    .clk(clk),
    .reset(reset),
    .[UART_SIZE-1:0] data_in(),
    .[UART_SIZE-1:0] data_out(),
    .wr_en(tx_fifo_wr_en),
    .rd_en(tx_fifo_rd_en),
    .empty(tx_fifo_empty),
    .full(tx_fifo_full),
    .error(tx_fifo_error)
    );
    */

    //axi4-lite handshake

    simple_fifo #(
    .DATA_WIDTH(UART_SIZE),
    .DEPTH(RX_DEPTH)
    ) rx_fifo (
    .clk(clk),
    .reset(reset),
    .data_in(rx_data),
    .data_out(), //out to axi4-lite
    .wr_en(rx_fifo_wr_en),
    .rd_en(rx_fifo_rd_en),
    .empty(rx_fifo_empty),
    .full(rx_fifo_full),
    .error(rx_fifo_error)
    );

    //gererate baud rate clock and 180 degree phase shift clock.
    baud_rate_generator_with_offset #(
        .SYS_CLK_FREQ(SYS_CLK_FREQ),            //system clock frequency in Hz
        .BAUD_RATE(BAUD_RATE),                  //desired baud rate
        .PHASE_OFFSET_DEG(SAMPLE_OFFSET)        //phase offset in degrees
    ) baud_gen (
        .clk(clk),                              //system clock input
        .reset(reset||phase_accum_reset),       //asynchronous reset
        .baud_tick(baud_tick),                  //baud rate tick output with 180 degree phase offset. only exists for one system clock cycle.
        .gen_clock(gen_clock),                  //generated clock
        .gen_clock_offset(gen_clock_offset)     //180deg phase shifted clock.
    );

    //synchronize inputs
    external_synchronizer #(
        .DATA_WIDTH(1)
    ) sync_rx (
        .clk(clk),
        .reset(reset),
        .data_in(RX),
        .data_out(RX_sync)
    );

    //uart reciever
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
        .crc_error(crc_error),
        .stop_error(stop_error),
        .RX(RX_sync),
        .done(rx_fifo_wr_en)
    );



endmodule