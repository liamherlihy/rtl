`timescale 1ns / 1ps

module blinky(
    input logic clk,
    input logic  reset,
    output logic led_o
);
reg[26:0] counter = '0;
//reg[0:0] led;
always @(posedge clk)begin
    if(reset)
        counter <= 27'h00;
    else 
        counter <= counter + 1'b1;
end
assign led_o = counter[26];
endmodule