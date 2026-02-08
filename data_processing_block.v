`timescale 1ns / 1ps

module data_processing_block (
    input              clk,
    input              rst,

    input              valid_in,
    output             ready_in,
    input      [7:0]   data_in,
    input      [1:0]   mode,

    output             valid_out,
    input              ready_out,
    output     [7:0]   data_out
);

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
        end else begin
            if (valid_in && ready_in) begin
                valid_reg <= 1'b1;
                case (mode)
                    2'b00: data_reg <= data_in;           // Bypass
                    2'b01: data_reg <= data_in + 8'd1;    // Increment
                    2'b10: data_reg <= ~data_in;          // Invert
                    2'b11: data_reg <= data_in << 1;      // Gain x2
                    default: data_reg <= data_in;
                endcase
            end else if (ready_out) begin
                valid_reg <= 1'b0;
            end
        end
    end

endmodule

