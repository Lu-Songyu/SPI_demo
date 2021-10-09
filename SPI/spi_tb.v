module tb_spi_intetface;

    reg clk;
    reg reset;
    reg [39:0] data;

    wire spi_sclk;
    wire spi_data;
    wire [7:0] counter;

    spi_interface DUT(
        .clk(clk),
        .reset(reset),
        .counter(counter),
        .data(data),
        .spi_sclk(spi_sclk),
        .spi_data(spi_data)
    );

    initial begin
        clk = 0;
        reset = 1l
        data = 0;
    end

    always # clk = ~clk;

    initial begin
        # 2 reset = 1'b0;
        #10 data = 40'
    end