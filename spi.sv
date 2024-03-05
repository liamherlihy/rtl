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

reg [7:0] data_o_reg;
reg [7:0] data_i_reg;
reg data_o_valid_reg;
reg data_i_valid_reg;
reg [2:0] state;
reg [7:0] shift_reg;
reg [7:0] shift_reg_out;
reg [7:0] shift_reg_in;
reg [7:0] shift_reg_in_reg;
reg [7:0] shift_reg_out_reg;
reg [7:0] shift_reg_in_reg_reg;
reg [7:0] shift_reg_out_reg_reg;


endmodule