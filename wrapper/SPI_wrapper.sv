module SPI_wrapper #(parameter A=10,N=8) (
    input reg[N*8-1:0] fileName,
    output wire spi_cs_l,
    output wire spi_sclk,           
    output wire spi_data,       
  	output [5:0] counter);
    
    reg [23:0] data_mem[A];
    reg  reset;
    reg  clk;
    reg [23:0] data_in;
    integer i;

    SPI_state_machine spi(
        .clk(clk),
        .reset(reset),
        .spi_cs_l(spi_cs_l),
        .counter(counter),
        .data_in(data_in),
        .spi_sclk(spi_sclk),
        .spi_data(spi_data));

    always #5 clk = ~clk;
 
    initial begin
  	    $readmemb($sformat("%s",fileName), data_mem);
    end 

    initial begin
        #10 reset = 0;
        for (i = 0; i < A; i = i + 1) begin
            #815 data_in = data_mem[i];
        end
    end
endmodule