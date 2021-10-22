// XRESET = 0 FOR 2000 CLOCK
// XRESET = 1
// WAIT 200 CLOCK 
// LOOP THRU SPI REGISTER WRITES

// FPGA is master, RF chip is slave
`timescale 1ns / 1ps

module spi_state(
    
    input wire clk,                 // System clk
    input wire reset,               // Asynchronous system reset
    input wire cycle_wait,          // cycles to wait 

    
    output wire spi_sclk,           // SPI bus clock
    output wire spi_data,           // SPI bus data
    output wire [7:0] counter,      // count will be decremented from 40 to 0, 7 bits is needed
    //output wire spi_cs,              SPI chip select
 
);

// reg
// ignore miso for now

reg [39:0] MOSI;                    // SPI shift register
reg [5:0] count;                    // control counter
// reg cs_slave;
reg sclk;
reg XREADY;
reg XWAIT;                   
reg [2:0] state;

// read data from csv: 2 byte for addr, 1 byte for data
reg [23:0] data_in [0:367];       
reg [23:0] data_cur;    
reg [9:0]  entry = 9'd368;          // 9 bit counter for read file line by line

initial begin
    
    /*file = $fopen("spi_cmds_simple.csv", "r");
    for (i=0; i<368; i++) begin
        $fscanf(file,"%b\n", data_in[i]);
    end
    $fclose(file);
    */

    $readmemb("data.mem", data_in);
end


always@(posedge clk or posedge reset)
    if(reset) begin
        MOSI  <= 40'b0;
        count <= 5'd24;
        sclk  <=  1'b0;
        XRESET <= cycle_wait;
        XREADY <= 1'b0;
    end

    else begin     
        /*
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
        */
        case(state)
            0: begin
                sclk   <= 1'b0;
                state  <= 1;
            end 
            1: begin
                sclk        <= 1'b0;
                data_cur    <= data_in[count-1];
                count       <= count-1;
                state       <= 2;
            end 

            2:begin
                sclk    <= 1'b1;
                if(count > 0)begin
                    state <= 1;
                end
                    
                else begin
                    MOSI = {8'd224, data_cur[23:7], 8'd1, data_cur[7:0] };
                    count <= 24;
                    state <= 0;
                end
            end

            default: state <= 0;
        
        endcase
    end

    
    assign spi_sclk = sclk;
    assign spi_data = MOSI;
    assign counter = count;


endmodule
