`timescale 1ns / 1ps

module data_prod_proc (
    input        clk,
    input        rst,
    input  [1:0] mode,
    output       valid_out,
    input        ready_out,
    output [7:0] data_out
);

    wire        prod_valid;
    wire        prod_ready;
    wire [7:0]  prod_data;

    // Producer
    data_producing_block producer (
        .clk       (clk),
        .rst       (rst),
        .valid_out (prod_valid),
        .ready_in  (prod_ready),
        .data_out  (prod_data)
    );

    // Processor
    data_processing_block processor (
        .clk       (clk),
        .rst       (rst),
        .valid_in  (prod_valid),
        .ready_in  (prod_ready),
        .data_in   (prod_data),
        .mode      (mode),
        .valid_out (valid_out),
        .ready_out (ready_out),
        .data_out  (data_out)
    );

endmodule

