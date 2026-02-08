`timescale 1ns / 1ps

module tb_data_prod_proc;

    reg         clk;
    reg         rst;
    reg  [1:0]  mode;
    reg         ready_out;
    reg         bypass_en;

    wire        valid_out;
    wire [7:0]  data_out;

    // DUT
    data_prod_proc dut (
        .clk       (clk),
        .rst       (rst),
        .mode      (mode),
        .bypass_en (bypass_en),
        .valid_out (valid_out),
        .ready_out (ready_out),
        .data_out  (data_out)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Dump waves (INCLUDING INTERNAL DATA)
        $dumpfile("data_prod_proc.vcd");
        $dumpvars(0, tb_data_prod_proc);

        // Explicit internal signals for waveform clarity
        $dumpvars(1,
            clk,
            rst,
            mode,
            bypass_en,
            ready_out,
            valid_out,
            data_out,
            dut.prod_data,
            dut.proc_data,
            dut.prod_valid
        );

        // Initialization
        clk       = 0;
        rst       = 1;
        mode      = 2'b00;
        ready_out = 0;
        bypass_en = 0;

        // Reset
        #20 rst = 0;

        // Enable downstream ready
        #10 ready_out = 1;

        // Normal processing modes
        #50 mode = 2'b01; // increment
        #50 mode = 2'b10; // invert

        // Enable BYPASS
        #40 bypass_en = 1;

        // Disable BYPASS, change mode
        #60 bypass_en = 0;
            mode = 2'b11; // shift left

        // Apply backpressure
        #40 ready_out = 0;
        #30 ready_out = 1;

        #100 $finish;
    end

endmodule

