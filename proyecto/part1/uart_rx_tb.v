`timescale 1ns/1ns

module uart_tx_tb();
    parameter CLK_PERIOD = 20;        // 50 MHz -> 20 ns
    parameter BAUD_RATE  = 115200;
    parameter CLK_FREQ   = 50000000;

    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg         clk        = 0;
    reg         rst        = 0;
    reg  [7:0]  data       = 8'h00;
    reg         send_data  = 0;
    wire        serial_out;

    // Instancia del DUT
    uart_tx #(
        .BASE_FREQ(CLK_FREQ),
        .BAUDRATE (BAUD_RATE)
    ) dut (
        .data       (data),
        .send_data  (send_data),
        .clk        (clk),
        .rst        (rst),
        .serial_out (serial_out)
    );

    // Generador de reloj
    always #(CLK_PERIOD/2) clk = ~clk;

    // Dump para GTKWave
    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);
    end

    // Tarea para enviar un byte
    task send_byte;
        input [7:0] tx_data;
        begin
            @(posedge clk);
            data <= tx_data;
            send_data <= 1;
            @(posedge clk);               // mantener por un ciclo de reloj
            send_data <= 0;

            // Esperar a que termine toda la trama (1 start + 8 datos + 1 paridad + 1 stop)
            #(BIT_PERIOD * CLK_PERIOD * 11); // 11 bits * tiempo por bit

            $display("Byte enviado: 0x%0h", tx_data);
        end
    endtask

    initial begin
        // Reset inicial
        rst = 1;
        #(CLK_PERIOD * 5);
        rst = 0;
        #(CLK_PERIOD * 5);

        $display("\nIniciando test de UART TX...\n");

        send_byte(8'h55);  // 01010101
        send_byte(8'hAA);  // 10101010
        send_byte(8'h3C);  // 00111100

        $display("\nTest de UART TX completado!\n");
        #100;
        $finish;
    end

endmodule
