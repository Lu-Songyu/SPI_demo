
`timescale 1ns / 1ns

module tb;
  reg clk;
  reg reset;
  reg [15:0] data_in;
  
  wire spi_sclk;
  wire spi_cs_l;
  wire spi_data;
  wire [5:0] counter;
 
  SPI_state_machine uut(
    .clk(clk),
    .reset(reset),
    .spi_cs_l(spi_cs_l),
    .counter(counter),
    .data_in(data_in),
    .spi_sclk(spi_sclk),
    .spi_data(spi_data)
  
  );
  
  initial 
    begin
      clk = 0;
      reset = 1;
      data_in = 0;
      
   end
  
  always #5 clk = ~clk;
  
  initial
    begin
      
      $dumpfile("dump.vcd"); $dumpvars;
      #10  data_in = 24'd16777200;
            reset = 0;
      #815 data_in = 24'd2000;
      #815 data_in = 24'd3000;
      #815 $finish;
    end
endmodule
