`timescale 1ns / 1ns

module tb_wrapper;
  wire spi_sclk;
  wire spi_cs_l;
  wire spi_data;
  wire [5:0] counter;

  string fileName = "data.mem";
  
  SPI_wrapper uut(A=366)(
    .fileName(fileName),
    .reset(reset),
    .spi_cs_l(spi_cs_l),
    .counter(counter),
    .spi_sclk(spi_sclk),
    .spi_data(spi_data)
  
  );
endmodule