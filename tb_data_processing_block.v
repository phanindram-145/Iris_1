`timescale 1ns/1ps

module tb_data_processing_block;

    reg clk;
    reg rst;

    reg        valid_in;
    wire       ready_in;
    reg [7:0]  data_in;
    reg [1:0]  mode;

    wire       valid_out;
    reg        ready_out;
    wire [7:0] data_out;

    data_processing_block dut (
        .clk       (clk),
        .rst       (rst),
        .valid_in  (valid_in),
        .ready_in  (ready_in),
        .data_in   (data_in),
        .mode      (mode),
        .valid_out (valid_out),
        .ready_out (ready_out),
        .data_out  (data_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

   initial begin
        // Initial values
        rst        = 1'b1;
        valid_in  = 1'b0;
        data_in   = 8'h00;
        mode      = 2'b00;
        ready_out = 1'b1;

        #20;
        rst = 1'b0;

        // Testing all modes
        send_pixel(2'b00, 8'hA5); // Bypass
        send_pixel(2'b01, 8'hC2); // Add +1
        send_pixel(2'b10, 8'hB3); // Invert
        send_pixel(2'b11, 8'h09); // Gain ×2

        #50;
        $display("TESTBENCH COMPLETED SUCCESSFULLY");
        $finish;
    end

    // Task to send one pixel
    task send_pixel;
        input [1:0] m;
        input [7:0] d;
        begin
            @(posedge clk);
            mode     = m;
            data_in  = d;
            valid_in = 1'b1;

            while (!ready_in)
                @(posedge clk);

            @(posedge clk);
            valid_in = 1'b0;

            while (!valid_out)
                @(posedge clk);

            $display("MODE=%b INPUT=%h OUTPUT=%h TIME=%0t",
                      m, d, data_out, $time);
        end
    endtask

endmodule

