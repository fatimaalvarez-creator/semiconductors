`timescale 1ns / 1ps

module uart_top_tb;

reg clk = 0;
reg rst = 0;
reg [7:0] data = 8'h00;
reg send_data = 0;

wire data_valid;
wire [7:0] parallel_out;

// Instancia del DUT (Device Under Test)
uart_top TOP (
    .clk(clk),
    .rst(rst),
    .data(data),
    .send_data(send_data),
    .data_valid(data_valid),
    .parallel_out(parallel_out)
);

// Generador de reloj (50 MHz)
always #10 clk = ~clk;  // Periodo de 20 ns

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, uart_top_tb);

    // Inicialización
    rst = 1;
    #40;
    rst = 0;

    // Espera antes de enviar datos
    #100;

    // Enviar primer dato
    data = 8'h55;
    send_data = 1;
    #20;
    send_data = 0;

    // Esperar suficiente tiempo para recepción UART
    #100000;

    // Enviar segundo dato
    data = 8'hAA;
    send_data = 1;
    #20;
    send_data = 0;

    // Esperar
    #100000;

    // Finalizar simulación
    $finish;
end

endmodule
