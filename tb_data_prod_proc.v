`timescale 1ns / 1ps

module tb_data_prod_proc;

    reg         clk;
    reg         rst;
    reg  [1:0]  mode;
    reg         ready_out;
    wire        valid_out;
    wire [7:0]  data_out;

    // DUT
    data_prod_proc dut (
        .clk       (clk),
        .rst       (rst),
        .mode      (mode),
        .valid_out (valid_out),
        .ready_out (ready_out),
        .data_out  (data_out)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Dump waves
        $dumpfile("data_prod_proc.vcd");
        $dumpvars(0, tb_data_prod_proc);

        // Init
        clk       = 0;
        rst       = 1;
        mode      = 2'b00;
        ready_out = 0;

        // Reset pulse
        #20;
        rst = 0;

        // Enable downstream ready
        #10;
        ready_out = 1;

        // Change modes over time
        #50 mode = 2'b01; // increment
        #50 mode = 2'b10; // invert
        #50 mode = 2'b11; // shift left

        // Apply backpressure
        #40 ready_out = 0;
        #30 ready_out = 1;

        // Finish
        #100;
        $finish;
    end

endmodule

