`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 04/13/2018 03:33:26 PM
// Design Name: Cmod S7-25 Out-of-Box Demo
// Module Name: top
// Target Devices: Cmod S7-25
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top (
    // 12MHz System Clock
    input wire clk,
    // RGB LED (Active Low)
    output wire led0_r,
    output wire led0_g,
    output wire led0_b,
    // 4 LEDs
    output wire [3:0] led,
    // UART TX
    output wire tx,
    // 2 Buttons
    input wire [1:0] btn
);
    localparam CD_COUNT_MAX = 12000000/2;
    wire brightness;
    reg [$clog2(CD_COUNT_MAX-1)-1:0] cd_count = 'b0;
    reg [3:0] led_shift = 4'b0001;
    wire [1:0] db_btn;
    
    wire uart_in_ready;
    wire uart_in_valid;
    wire [15:0] uart_data_in;
    
    wire exec_in_ready;
    wire exec_in_valid;
    wire [15:0] exec_data_in;
    
    wire program_rom_in_valid;
    wire program_rom_in_ready;
    wire [3:0] program_rom_address;
        
    pwm #(
        .COUNTER_WIDTH(8),
        .MAX_COUNT(255)
    ) m_pwm (
        .clk(clk),
        .duty(8'd127),
        .pwm_out(brightness)
    );
    
    always@(posedge clk)
        if (cd_count >= CD_COUNT_MAX-1) begin // 2Hz
            cd_count <= 'b0;
            led_shift <= {led_shift[2:0], led_shift[3]}; // cycle the LEDs and the color of the RGB LED
        end else
            cd_count <= cd_count + 1'b1;
    assign led = led_shift;
    assign {led0_r, led0_g, led0_b} = ~(led_shift[2:0] & {3{brightness}});
    
    debouncer #(
        .WIDTH(2),
        // Simulation
        //.CLOCKS(2),
        //.CLOCKS_CLOG2(1)
        .CLOCKS(256),
        .CLOCKS_CLOG2(8)
    ) m_db_btn (
        .clk(clk),
        .din(btn),
        .dout(db_btn)
    );
    
    // Transmit "Button <#> Pressed!" whenever btn0 or btn1 is pressed.
    uart_tx #(
        .DATA_BUS_WIDTH(16),
        .BAUD_2_CLOCK_RATIO(12000000 / 9600),
        //.BAUD_2_CLOCK_RATIO(1), // Simulation
        .UART_DATA_BITS(8),
        .UART_STOP_BITS(2)
    ) m_uart_tx (
        .clk(clk),
        .in_valid(uart_in_valid),
        .tx(tx),
        .in_ready(uart_in_ready),
        .data_in(uart_data_in)
    );
    
    exec # (
        .DATA_WIDTH(16)
    ) m_exec (
        .clk(clk),
        .reset(db_btn[1]),
        .in_instruction(exec_data_in),
        .in_valid(exec_in_valid),
        .in_ready(exec_in_ready),
        .out_data(uart_data_in),
        .out_valid(uart_in_valid),
        .out_ready(uart_in_ready)
    );
    
    program_rom # (
        .address_length(4),
        .data_length(16)
    ) m_program_rom (
        .clk(clk),
        .reset(db_btn[1]),
        .address(program_rom_address),
        .in_valid(program_rom_in_valid),
        .in_ready(program_rom_in_ready),
        .out_valid(exec_in_valid),
        .out_ready(exec_in_ready),
        .data_out(exec_data_in)
    );
    
    program_counter # (
        .address_length(4)
    ) m_program_counter (
        .clk(clk),
        .reset(db_btn[1]),
        .out_valid(program_rom_in_valid),
        .out_ready(program_rom_in_ready),
        .rom_address(program_rom_address)
);
        
    
    
endmodule
