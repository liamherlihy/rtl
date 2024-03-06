`timescale 1ns/1ps

module tb_uart_rx;

    parameter UART_SIZE = 8;
    parameter CLK_PERIOD = 8; // Clock period in nanoseconds
    parameter BAUD_RATE = 115200; // Baud rate in bps
    parameter SYS_CLK_FREQ = 125000000; // System clock frequency in Hz
    parameter BAUD_TICKS = SYS_CLK_FREQ / BAUD_RATE; // Number of system clock cycles per baud period

    // Testbench signals
    logic clk;
    logic reset;
    logic baud_tick;
    logic phase_accum_reset;
    logic [UART_SIZE-1:0] rx_data;
    logic parity_enable;
    logic parity_type; // 0 = odd, 1 = even
    logic crc_error;
    logic stop_error;
    logic RX;

    // Instantiate the uart_rx module
    uart_rx #(
        .UART_SIZE(UART_SIZE)
    ) dut (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .phase_accum_reset(phase_accum_reset),
        .rx_data(rx_data),
        .parity_enable(parity_enable),
        .parity_type(parity_type),
        .crc_error(crc_error),
        .stop_error(stop_error),
        .RX(RX)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize signals
        reset = 1;
        RX = 1; // Idle state of RX is high
        parity_enable = 0; // Start with parity disabled
        parity_type = 0; // Odd parity (not used initially)
        baud_tick = 0;

        // Reset the system
        #(CLK_PERIOD * 10);
        reset = 0;
        #(CLK_PERIOD * 2);

        // Start test sequence
        // Send a start bit (RX goes low)
        RX = 0; baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2); // Adjust this to your baud rate; here assuming one start bit duration + some tolerance
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        // Send data bits (LSB first)
        // Sending 8'b01100101 for example
        RX = 1;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 1;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 1;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 1;
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 0;
        //end of data
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        RX = 1;
        //stop bit
        #(CLK_PERIOD * BAUD_TICKS/2);
        baud_tick = 1;
        #CLK_PERIOD;
        baud_tick = 0;
        #(CLK_PERIOD * BAUD_TICKS/2);
        #(CLK_PERIOD * BAUD_TICKS*3);

        // If parity is enabled, send parity bit (not applicable here)

        // Send stop bit
        RX = 1;
        #(CLK_PERIOD * BAUD_TICKS);

        // Wait and check results
        #(CLK_PERIOD * 10);
        if (rx_data != 8'b01100101) begin
            $display("Test failed: Incorrect data received.");
        end else begin
            $display("Test passed: Correct data received.");
        end

        // Add more test scenarios as needed
        // End of test

    end

    // Optional: Add additional tasks or functions for different test scenarios

endmodule
