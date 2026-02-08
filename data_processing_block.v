`timescale 1ns / 1ps

module data_processing_block
(
    input              clk,
    input              rst,

    input              valid_in,
    output             ready_in,
    input  [7:0]       data_in,
    input  [1:0]       mode,

    output             valid_out,
    input              ready_out,
    output [7:0]       data_out
);

    // Mode definitions for clarity
    localparam MODE_BYPASS = 2'b00;
    localparam MODE_INC    = 2'b01;
    localparam MODE_INV    = 2'b10;
    localparam MODE_GAIN   = 2'b11;

    reg [7:0] data_reg;
    reg       valid_reg;

    // Ready/Valid handshake logic
    assign ready_in  = (~valid_reg) | ready_out;
    assign valid_out = valid_reg;
    assign data_out  = data_reg;

    always @(posedge clk) begin
        if (rst) begin
            data_reg  <= 8'b0;
            valid_reg <= 1'b0;
        end
        else begin
            if (valid_in && ready_in) begin
                valid_reg <= 1'b1;
                case (mode)
                    MODE_BYPASS: data_reg <= data_in;        // Bypass
                    MODE_INC:    data_reg <= data_in + 1'b1; // Increase
                    MODE_INV:    data_reg <= ~data_in;       // Invert
                    MODE_GAIN:   data_reg <= data_in << 1;   // Gain x2
                    default:     data_reg <= data_in;
                endcase
            end
            else if (ready_out) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule