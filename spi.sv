`timescale 1ns / 1ps

module spi #(
    parameter SPI_SIZE = 8
    )(
    input logic clk,
    input logic reset,
    input logic [7:0] data_i,
    input logic data_i_valid,
    output logic data_o_valid,
    output logic [7:0] data_o
    );

logic [SPI_SIZE-1:0] 


endmodule