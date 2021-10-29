
`timescale 1ns / 1ns

module tb;
  reg clk;
  reg reset;
  reg [23:0] data_in;
  
  wire spi_sclk;
  wire spi_cs_l;
  wire spi_data;
  wire [5:0] counter;
  
  reg [23:0] data_mem [0:366];

  integer i;
  
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
  
  initial begin
    $readmemb("data.mem", data_mem);
  end

  initial
    begin
      
      $dumpfile("dump.vcd"); $dumpvars;
      #10 reset = 0;
      for (i = 0; i < 367; i = i + 1) begin
        #815 data_in = data_mem[i];
      end
      //   data_in = 24'd16777200;
            
      // #815 data_in = 24'd2000;
      // #815 data_in = 24'd3000;
      #815 $finish;
    end
endmodule

