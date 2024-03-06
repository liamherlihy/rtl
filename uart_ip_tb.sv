`timescale 1ns/1ps

module uart_up_tb;

    parameter UART_SIZE = 8;
    parameter CLK_PERIOD = 8; // Clock period in nanoseconds
    parameter BAUD_RATE = 115200; // Baud rate in bps
    parameter SYS_CLK_FREQ = 125000000; // System clock frequency in Hz
    parameter SAMPLE_OFFSET = 180;
    parameter PARITY_ENABLE = 0;                //active high
    parameter PARITY_TYPE = 0;                  //0 for odd, 1 for even
    parameter CRC_ENABLE = 0;

    parameter BAUD_TICKS = SYS_CLK_FREQ / BAUD_RATE; // Number of system clock cycles per baud period

    logic clk;      //input 
    logic reset;    //input 
    logic RX;       //input 
    logic TX;       //input 
    logic RTS;      //output
    logic CTS;      //output
    
    uart_ip #(
    .UART_SIZE(UART_SIZE),
    .BAUD_RATE(BAUD_RATE),
    .SYS_CLK_FREQ(SYS_CLK_FREQ),
    .SAMPLE_OFFSET(SAMPLE_OFFSET),
    .PARITY_ENABLE(PARITY_ENABLE),                //active high
    .PARITY_TYPE(PARITY_TYPE),                  //0 for odd, 1 for even
    .CRC_ENABLE(CRC_ENABLE)
    ) uart_ip (
        .clk(clk),
        .reset(reset),
        .RX(RX),
        .TX(TX),
        .RTS(RTS),
        .CTS(CTS)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        reset = 1;
        RX = 1;
        CTS = 1;

        #(CLK_PERIOD * 10); //wait 10 clock cycles (80ns)
        reset = 0;
        #(CLK_PERIOD * 10); //wait 2 clock cycles (80ns)
        //sending data 8'b11011001, LDSB first
        RX = 0; //start bit
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 0
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 1
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 2
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 3
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 4
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 5
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 6
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //bit 7
        #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
        RX = 1; //stop bit
        #(CLK_PERIOD * 10); //wait 10 clock cycles (80ns)
    end

endmodule