module top(
    input logic			CLOCK_50,
    input logic [3:0]	KEY,
    output logic [9:0] 	LEDR,
    output logic [6:0]	HEX0,
	output logic [6:0]	HEX1,
    input logic RX_PIN,
    output logic TX_PIN
);

	logic [7:0] read_data;
	logic read, address, cs;

	uart u0 (
		.clk_clk                                       (CLOCK_50),                                       //                                clk.clk
		.controller_uart_bridge_0_cpu_slave_chipselect (cs), // controller_uart_bridge_0_cpu_slave.chipselect
		.controller_uart_bridge_0_cpu_slave_readdata   (read_data),   //                                   .readdata
		.controller_uart_bridge_0_cpu_slave_address    (address),    //                                   .address
		.controller_uart_bridge_0_cpu_slave_read       (read),       //                                   .read
		.reset_reset_n                                 (KEY[0]),                                 //                              reset.reset_n
		.rs232_0_external_interface_RXD                (RX_PIN),                //         rs232_0_external_interface.RXD
		.rs232_0_external_interface_TXD                (TX_PIN)                 //                                   .TXD
	);

	assign LEDR[0] = KEY[0];

	assign read = 1'b1;
	assign cs = 1'b1;

	logic button;
	logic [7:0] hex;

	enum {BUT, HEX} state;

	always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
		if (!KEY[0]) begin
			address <= 1'b0;
		end else begin
			address <= ~address;
            if (address) button <= read_data[0];
            else hex <= read_data;
		end
	end

	hex7seg hex2(.hexIn(hex[3:0]), .HEX0(HEX0));
	hex7seg hex3(.hexIn(hex[7:4]), .HEX0(HEX1));

	assign LEDR[9] = button;
endmodule

module hex7seg( input  logic [3:0] hexIn,
                input logic blank,
                output logic [6:0] HEX0);
    always_comb begin
        if (blank) begin
            HEX0 = 7'b1111111;
        end else begin
            case (hexIn)
                4'h0: HEX0 = 7'b1000000; // 0
                4'h1: HEX0 = 7'b1111001; // 1
                4'h2: HEX0 = 7'b0100100; // 2
                4'h3: HEX0 = 7'b0110000; // 3
                4'h4: HEX0 = 7'b0011001; // 4
                4'h5: HEX0 = 7'b0010010; // 5
                4'h6: HEX0 = 7'b0000010; // 6
                4'h7: HEX0 = 7'b1111000; // 7
                4'h8: HEX0 = 7'b0000000; // 8
                4'h9: HEX0 = 7'b0010000; // 9
                4'hA: HEX0 = 7'b0001000; // A
                4'hB: HEX0 = 7'b0000011; // b
                4'hC: HEX0 = 7'b1000110; // C
                4'hD: HEX0 = 7'b0100001; // d
                4'hE: HEX0 = 7'b0000110; // E
                4'hF: HEX0 = 7'b0001110; // F
                default: HEX0 = 7'b1111111; // blank
            endcase
        end
    end

endmodule
