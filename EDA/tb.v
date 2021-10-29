
`timescale 1ns / 1ns

module tb;
  reg clk;
  reg reset;
  reg [15:0] data_in;
  
  wire spi_sclk;
  wire spi_cs_l;
  wire spi_data;
  wire [4:0] counter;
  
  
  
  // MISO word to transmit 1st = 12'b110101110011 or 12'hD73
  // MISO word to transmit 2nd = 12'b000000000011 or 12'h3
 
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
      #10  data_in = 16'b00000000000000000001;
      #335 data_in = 16'b00000000000000000010;
      #335 data_in = 16'b00000000000000000011;
      #335 $finish;
    end
endmodule
