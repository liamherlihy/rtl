module simple_fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 16
) (
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    input logic wr_en,
    input logic rd_en,
    output logic empty,
    output logic full,
    output logic error
);
    logic [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0] ='{default:0};
    logic [$clog2(DEPTH)-1:0] wr_counter = 0;
    logic [$clog2(DEPTH)-1:0] rd_counter = 0;
    logic error_hold = 0;
    logic [$clog2(DEPTH):0] fifo_counter = '{default:0};

    always_ff @(posedge clk) begin
        if (reset) begin
            //fifo_mem <= '{default:0};
            wr_counter <= 0;
            rd_counter <= 0;
            fifo_counter <= 0;
            error_hold <= 1;
        end
        else begin
            if (wr_en) begin
                fifo_mem[wr_counter] <= data_in;
                wr_counter <= wr_counter + 1;
            end
            
            if (rd_en) begin
                data_out <= fifo_mem[rd_counter];
                rd_counter <= rd_counter + 1;
            end
            //handle the fifo counter          
            if (wr_en && rd_en) 
                fifo_counter <= fifo_counter;      
            else if (wr_en) 
                fifo_counter <= fifo_counter + 1;
            else if(rd_en) 
                fifo_counter <= fifo_counter - 1;
                
           if (fifo_counter[$clog2(DEPTH)]&(&fifo_counter[$clog2(DEPTH):0]))
                error_hold <= 1;
        end
    end

    always_comb begin
        if (fifo_counter == 0)
            empty = 1;
        else 
            empty = 0;
        full = fifo_counter[$clog2(DEPTH)];
        error = fifo_counter[$clog2(DEPTH)] & (&fifo_counter[$clog2(DEPTH)-1:0]);    
    end

endmodule