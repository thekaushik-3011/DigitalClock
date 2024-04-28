`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2024 08:50:04
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_DigitalClock;

reg clk = 0;
reg reset, start_stop, reset_stopwatch, set_hour, set_min, set;
reg [1:0] mode_sel;

wire [6:0] seg_data; 
wire [3:0] digit_sel;   
wire [5:0] blink;
wire [1:0] blue;
wire [1:0] red;
wire [1:0] green;

DigitalClock dut (
   .clk(clk),
   .reset(reset),
   .start_stop(start_stop),
   .reset_stopwatch(reset_stopwatch),
   .mode_sel(mode_sel),
   .set_hour(set_hour),
   .set_min(set_min),
   .set(set),
   .seg_data(seg_data),
   .digit_sel(digit_sel),
   .blink(blink),
   .blue(blue),
   .red(red),
   .green(green)
);

// Clock initialization
always #1 clk = ~clk; // 10ns clock period
   
   
initial begin
   // Test digital clock mode
   mode_sel = 2'b00;
   start_stop = 1'b0;
   reset_stopwatch = 1'b0;
   set_hour = 1'b0;
   set_min = 1'b0;
   set = 1'b0;
   #2;
   reset = 1'b1;
   #10; // Simulate for 10 time units
   reset = 1'b0;
   #137;
   
   // Test stopwatch mode
   mode_sel = 2'b01;
   reset = 1'b0;
   start_stop = 1'b1; 
   #20;
   reset_stopwatch = 1'b1;
   #5; // Simulate for 5 time units
   reset_stopwatch = 1'b0;
   #5;

   // Test timer mode
   mode_sel = 2'b10;
   reset = 1'b0;
   set = 1'b1;
   set_hour = 1'b0;
   set_min = 1'b1;
   #4; // Simulate setting minute for 5 time units
   set_min = 1'b0;
   #2;
   set = 1'b0;
   
   #200; // Simulate timer running for 200 time units

   // Test alarm mode
   mode_sel = 2'b11;
   reset = 1'b0;
   set_hour = 1'b0;
   set_min = 1'b1;
   #20; // Simulate setting alarm minute for 100 time units
   set_hour = 1'b0;
   set_min = 1'b0;
   #200; // Simulate alarm waiting for 200 time units

   $finish; // End simulation
end

endmodule