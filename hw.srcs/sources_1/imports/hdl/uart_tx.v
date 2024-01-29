`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 04/13/2018 03:33:26 PM
// Module Name: uart_tx 
// Description: Prints "Button # Pressed!" whenever any one button (#) is pressed
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(
    parameter DATA_BUS_WIDTH = 16,
    parameter BAUD_2_CLOCK_RATIO = 12000000 / 9600, // frequency of clk / target baud rate 
	parameter UART_DATA_BITS = 8,
	parameter UART_STOP_BITS = 2
) (
    input wire clk,
    input wire in_valid,
    input wire [DATA_BUS_WIDTH-1:0] data_in,
    output reg tx,
    output reg busy = 1'b0,
    output reg in_ready
);
    localparam STRING_LENGTH = 2;
    localparam BYTE_COUNT_WIDTH = 5; // = $clog2(STRING_LENGTH)
	
	//  CONTROLLER:
//	reg busy = 1'b0;
	wire start = (busy == 1'b0 && in_valid == 1'b1) ? 1'b1 : 1'b0; // NOTE: if a press is detected while the controller is busy, the event will be missed
	
	//  COUNTERS:
	//  pseudo for counters:
	//	    for byte_count in range(STRING_LENGTH)
	//      for bit_count in range(-1, UART_DATA_BITS+UART_STOP_BITS-1)
	//      for cd_count in range(BAUD_2_CLOCK_RATIO)
	reg [$clog2(BAUD_2_CLOCK_RATIO)-1:0] cd_count; // clock divider counter, rolls over at approx. target baud rate 
	reg [$clog2(UART_DATA_BITS+UART_STOP_BITS+1)-1:0] bit_count; // uart frame bit counter
	reg [BYTE_COUNT_WIDTH-1:0] byte_count; // string index counter
	wire end_of_bit = (cd_count == BAUD_2_CLOCK_RATIO-1) ? 1'b1 : 1'b0;
	wire end_of_byte = (end_of_bit == 1'b1 && bit_count == UART_DATA_BITS+UART_STOP_BITS-1) ? 1'b1 : 1'b0;
	wire end_of_string = (end_of_byte == 1'b1 && byte_count == STRING_LENGTH-1) ? 1'b1 : 1'b0;
	
	// DATA:
	reg [UART_DATA_BITS-1:0] data = 'b0; // character to be sent over UART
	reg r_btn_event = 1'b0; // contains the ID of the pressed button
	reg [DATA_BUS_WIDTH-1:0] data_bus_reg;

	// CONTROLLER LOGIC:	
	always@(busy, bit_count, data)
		if (busy == 1'b0) // hold tx high when not in use
			tx = 1'b1;
		else if (&bit_count == 1'b1) // START BIT (bit_count == -1)
			tx = 1'b0;
		else if (bit_count < UART_DATA_BITS) // DATA BITS
			tx = data[bit_count];
		else // STOP BITS
			tx = 1'b1;
	
    always@(posedge clk)
        if (start == 1'b1) begin
		    data_bus_reg <= data_in;
            busy <= 1'b1;
        end else if (end_of_string == 1'b1)
            busy <= 1'b0;
        else
            busy <= busy;
            
    always@(busy)
        in_ready <= !busy;
			
	// COUNTERS LOGIC:
	// each counter is configured to roll over at the applicable end_of_* signal, and reset when the transmitter is not busy
	always@(posedge clk)
		if (busy == 1'b0 || end_of_bit == 1'b1)
			cd_count <= 'b0;
		else
			cd_count <= cd_count + 1'b1;
	
	always@(posedge clk)
		if (busy == 1'b0 || end_of_byte == 1'b1)
			bit_count <= ~'b0; // bit_count = -1
		else if (end_of_bit == 1'b1)
			bit_count <= bit_count + 1;
	
	always@(posedge clk)
		if (busy == 1'b0 || end_of_string == 1'b1)
			byte_count <= 'b0;
		else if (end_of_byte == 1'b1)
			byte_count <= byte_count + 1;
        
	// DATA LOGIC:		  
    always@(byte_count, busy) // select a character to send
		case (byte_count)
		0: data <= data_bus_reg[15:8];
		1: data <= data_bus_reg[7:0];
		default: data <= "?"; // unreachable code
		endcase
	
endmodule
