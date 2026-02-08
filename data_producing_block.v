`timescale 1ns / 1ps

module data_producing_block (
    input            clk,
    input            rst,
    output reg       valid_out,
    input            ready_in,
    output reg [7:0] data_out
);

    always @(posedge clk) begin
        if (rst) begin
            valid_out <= 1'b0;
            data_out  <= 8'h0;
        end
        else begin
            if (ready_in) begin
                valid_out <= 1'b1;
                data_out  <= data_out + 8'h1;
            end
            // else: hold current valid_out and data_out
        end
    end

endmodule

