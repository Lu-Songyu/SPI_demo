// XRESET = 0 FOR 2000 CLOCK
// XRESET = 1
// WAIT 200 CLOCK 
// LOOP THRU SPI REGISTER WRITES

// FPGA is master, RF chip is slave

module spi_state(
    input wire clk,                 // System clk
    input wire reset,               // Asynchronous system reset
    input wire cycle_wait,          // cycles to wait 
    output wire [39:0] data,        // data bus
    output wire spi_sclk,           // SPI bus clock
    output wire spi_data,           // SPI bus data
    output wire [7:0] counter,      // count will be decremented from 40 to 0, 7 bits is needed
    output wire spi_cs,             // SPI chip select
 
);

// reg
// ignore miso for now
reg [39:0] MOSI;                    // SPI shift register
reg [7:0] count;                    // control counter
// reg cs_slave;
reg sclk;
reg XREADY;
reg XRESET;                          // XRESET
reg [2:0] state;

always@(posedge clk or posedge reset)
    if(reset) begin
        MOSI  <= 40'b0;
        count <= 7'd40;
        sclk  <=  1'b0;
        XRESET <= cycle_wait;
        XREADY <= 1'b0;
    end
    else begin
        case(state)
            0: begin
                sclk   <= 1'b0;
                state  <= 1;
            end      

            1: begin
                // wait 200 before XREADY = 1
                sclk = 1'b1;
                if (XRESET) begin
                    XREADY <= 1;
                    XRESET <= cycle_wait;
                    state  <= 2;
                else begin
                    XRESET <= XRESET - 1;
                end
                sclk = 1'b0;
            end

            2: begin
                // wait another 200 clock after XREADY = 1
                sclk <= 1'b1;
                if(XRESET) begin
                    state <= 3;
                else begin
                    XRESET = XRESET-1;
                end
            end 

            3: begin
                sclk = 1'b1;
                if (count > 0) begin
                    MOSI  <= data[count-1];
                    count <= count - 1;
                else begin
                    count <= 7'd40;
                end
                sclk = 1'b0;
            end 

            default: state <= 0;
        endcase
    end

    assign spi_sclk = sclk;
    assign spi_data = MOSIl
    assign counter = count;
end