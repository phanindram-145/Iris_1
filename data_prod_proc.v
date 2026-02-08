`timescale 1ns / 1ps

module data_prod_proc (
    input        clk,
    input        rst,
    input  [1:0] mode,
    input        bypass_en,   // NEW
    output       valid_out,
    input        ready_out,
    output [7:0] data_out
);

    wire        prod_valid;
    wire        prod_ready;
    wire [7:0]  prod_data;

    wire        proc_valid;
    wire [7:0]  proc_data;

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
        .valid_out (proc_valid),
        .ready_out (ready_out),
        .data_out  (proc_data)
    );

    assign valid_out = bypass_en ? prod_valid : proc_valid;
    assign data_out  = bypass_en ? prod_data  : proc_data;

    assign prod_ready = ready_out;

endmodule

