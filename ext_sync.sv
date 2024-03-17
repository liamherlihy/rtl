module external_synchronizer #(
    parameter DATA_WIDTH = 1
) (
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);
    logic [DATA_WIDTH-1:0]synch_data[1:0] = '{default:0}; //unpacked array of 2 elements

    always_ff @(posedge clk) begin
        if (reset) 
            data_out <= 0;
        else begin
            synch_data[0] <= data_in;
            synch_data[1] <= synch_data[0];
            data_out <= synch_data[1];
        end
    end
endmodule