// Módulo UART TOP que integra transmisor y receptor UART

module uart_top (
    input clk,
    input rst,
    input [7:0] data,
    input send_data,

    output wire data_valid,
    output wire [7:0] parallel_out
);

wire serial_wire;

uart_tx #(.BAUDRATE(115200)) uart_tx1 (
    .data(data),
    .send_data(send_data),
    .clk(clk),
    .rst(rst),
    .serial_out(serial_wire)
);

uart_rx #(.BAUDRATE(115200)) uart_rx1 (
    .clk(clk),
    .serial_in(serial_wire),
    .rst(rst),
    .parallel_out(parallel_out),
    .data_valid(data_valid)
);

endmodule
