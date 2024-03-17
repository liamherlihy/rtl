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

    logic clk = 0;      //input 
    logic reset = 1;    //input 
    logic RX = 1;       //input 
    logic TX = 0;       //input 
    logic RTS = 0;      //output
    logic CTS = 0;      //output
    logic [UART_SIZE-1:0]message = 0;

    
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

     wire [UART_SIZE-1:0]rx_data = uart_ip.rx_data ;
     wire done = uart_ip.done;
     
    // Clock generation
    always begin
        clk = 1'b0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end
    
    //check RX data vs registered data.
    always @(posedge clk) begin
        if(done) begin
            if(rx_data == message) begin
                $timeformat(-9,2, " ns");
                $display("sent %0h, received %0h at %t. valid recieve", message, rx_data, $time);              
            end          
            else begin
                $display("sent %0h, received %0h. invalid recieve", message, rx_data);
            end  
        end
        else;
    end      

    initial begin
        message = 8'h53;
        reset_module;
        rx_packet(message);            
    end

    task rx_packet;
        input [7:0]data; 
        //re-write as forloop
        begin
            RX = 1'b0; //start bit
            $display("writing start bit, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            $display("waiting %0d time", (CLK_PERIOD * BAUD_TICKS));
            RX = data[0]; //bit 0
            $display("writing data bit 0, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[1]; //bit 1
            $display("writing data bit 1, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[2]; //bit 2
            $display("writing data bit 2, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[3]; //bit 3
            $display("writing data bit 3, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[4]; //bit 4
            $display("writing data bit 4, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[5]; //bit 5
            $display("writing data bit 5, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[6]; //bit 6
            $display("writing data bit 6, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = data[7]; //bit 7
            $display("writing data bit 7, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            RX = 1; //stop bit
            $display("writing stop bit, RX: %0d", RX);
            #(CLK_PERIOD * BAUD_TICKS); //wait 10 clock cycles (80ns)
            end
    endtask;
    
    task reset_module();
        begin
            $display("put core in reset");
            reset = 1'b1;
            RX = 1'b1;
            CTS = 1'b1;
    
            #(CLK_PERIOD * 100); //wait 10 clock cycles (80ns)
            reset = 1'b0;
            $display("pull core out of reset");
            #(CLK_PERIOD * 100); //wait 2 clock cycles (80ns)
        end
    endtask;  
    
endmodule