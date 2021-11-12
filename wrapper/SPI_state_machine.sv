////////////////////////////////////////////////////////////////////////
//
//
//     SPI for MCP3202 ADC
//
//
//      By Dominic Meads
//
////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module SPI_state_machine(
	  input wire clk,                 // System clk
    input wire reset,               // Asynchronous system reset
    
  	input wire [23:0]data_in,
  	output wire spi_cs_l,
    output wire spi_sclk,           // SPI bus clock
    output wire spi_data,           // SPI bus data
  	output [5:0] counter      
);


	//reg [39:0] MOSI;                    // SPI shift register
    wire [40:0] temp;
  	reg MOSI;
  	reg [5:0] count;                   // control counter

    reg sclk;
    reg cs_l;                  
    reg [2:0] state;

    assign temp = {8'b11111111, data_in[23:8], 8'd1, data_in[7:0]};
    // read data from csv: 2 byte for addr, 1 byte for data
    //reg [23:0] data_in [0:367];       
    //reg [23:0] data_cur;    
    //reg [9:0]  entry = 9'd368;          // 9 bit counter for read file line by line
	 
	
	always@(posedge clk or posedge reset)
    if(reset) begin
        //data_bus  <= 24'b0;
      	MOSI  <= 0;
        count <= 6'd40;
        sclk  <=  1'b0;
        cs_l  <=  1'b1;
    end

    else begin     
        
        case(state)
            0: begin
                sclk   <= 1'b0;
              	cs_l   <= 1'b1;
                state  <= 1;
            end 
            1: begin
                sclk        <= 1'b0;
              	cs_l        <= 1'b0;
                // data_bus	<= data_temp[count-1];
                MOSI	      <= temp[count-1];
                count       <= count-1;
                state       <= 2;
            end 

            2:begin
                sclk    <= 1'b1;
                if(count > 0)begin
                    state <= 1;
                end
                    
                else begin
                    //MOSI = {8'd224, data_bus[23:7], 8'd1, data_bus[7:0] };
                    
                    count <= 6'd40;
                    state <= 0;
                end
            end

            default: state <= 0;
        
        endcase
    end

    
    assign spi_sclk = sclk;
    assign spi_data = MOSI;
    assign counter = count;
  	assign spi_cs_l = cs_l;

endmodule 		
			