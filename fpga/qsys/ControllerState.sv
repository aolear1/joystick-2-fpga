module ControllerState (
    //top level signals
    input logic clk,
    input logic rst_n,

    //Master Signals; UART facing
    output logic m_address,
    output logic m_cs,
    output logic [3:0] m_byte_enable,
    output logic m_read,
    output logic m_write,
    output logic [31:0] m_write_data,
    input logic [31:0] m_read_data,

    input logic irq,

    //Slave Signals; CPU facing
    input logic s_address,
    input logic s_cs,
    input logic s_read,
    output logic [7:0] s_read_data
    );

/*Initial Assign Logic*/
assign m_write_data = 32'h0;
assign m_cs = 1'b1;

/*UART logic*/
enum {DELAY, WAIT, READ} state;
logic [6:0] data[1:0];
logic [1:0] counter;
logic [7:0] read_byte;

assign read_byte = m_read_data[7:0];

logic data_valid;
assign data_valid = m_read_data[15];

always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
        state <= DELAY;
        data[1] <= 7'd0;
        data[0] <= 7'd0;
    end else begin
        case(state)
            DELAY: begin
                state <= WAIT;
            end
            WAIT: begin
                if (data_valid) begin
                    state <= READ;
                end
            end

            READ: begin
                data[read_byte[7]] <= read_byte[6:0];
                state <= DELAY;
            end
        endcase
    end
end


always_comb begin
    m_read = 1'b0;
    m_byte_enable = 4'b0000;
    m_address = 1'b0;

    case(state)
        DELAY: begin
            m_read = 1'b1;
            m_byte_enable = 4'b0010;
        end
        WAIT: begin
            m_read = 1'b1;
            m_byte_enable = (data_valid) ? 4'b0001 : 4'b0010;
        end
    endcase
end

assign s_read_data = (s_read & s_cs) ? (s_address) ? {7'd0, data[1][0]}: {data[1][1], data[0]} : 8'bzzzzzzzz;

endmodule
