`timescale 1ns/1ns

module uart_rx_tb();
	// Parámetros de prueba
	parameter CLK_PERIOD = 20; // 50 MHz -> 20ns
	parameter BAUD_RATE = 921600;
	parameter CLK_FREQ = 50000000;
	
	// Tiempo por bit según baudrate (en periodos de reloj)
	localparam BIT_PERIOD = CLK_FREQ/BAUD_RATE;
	
	// Señales para el módulo bajo prueba
	reg clk = 0;
	reg rst = 0;
	reg serial_in = 1; // Línea en alto en reposo
	wire [7:0] parallel_out;
	wire data_valid;
	
	// Datos de prueba
	reg [7:0] test_data [2:0]; // Array de 3 bytes de prueba
	
	// Instancia del módulo RX
	uart_rx #(
		.BASE_FREQ(CLK_FREQ),
		.BAUDRATE(BAUD_RATE)
	) dut (
		.clk(clk),
		.rst(rst),
		.serial_in(serial_in),
		.parallel_out(parallel_out),
		.data_valid(data_valid)
	);
	
	// Generador de reloj
	always #(CLK_PERIOD/2) clk = ~clk;
	
	// Función para enviar un byte por la línea serial
	// Simula lo que haría el módulo TX
	task send_byte;
		input [7:0] data;
		integer i;
		reg parity;
		begin
			// Calculamos la paridad par (igual que en TX)
			parity = ^data ? 1'b1 : 1'b0; // XOR de todos los bits
			
			// Bit de inicio (siempre 0)
			serial_in = 1'b0;
			#(BIT_PERIOD * CLK_PERIOD);
			
			// Bits de datos (LSB primero)
			for (i = 0; i < 8; i = i + 1) begin
				serial_in = data[i];
				#(BIT_PERIOD * CLK_PERIOD);
			end
			
			// Bit de paridad
			serial_in = parity;
			#(BIT_PERIOD * CLK_PERIOD);
			
			// Bit de parada (siempre 1)
			serial_in = 1'b1;
			#(BIT_PERIOD * CLK_PERIOD);
			
			// Un poco de tiempo extra en reposo
			#(CLK_PERIOD * 5 * BIT_PERIOD);
		end
	endtask
	
	// Test principal
	initial begin
		// Inicialización de datos de prueba
		test_data[0] = 8'h55; // 01010101
		test_data[1] = 8'hAA; // 10101010
		test_data[2] = 8'h3C; // 00111100
		
		// Reseteo inicial
		rst = 1;
		#(CLK_PERIOD * 5);
		rst = 0;
		#(CLK_PERIOD * 5);
		
		// Mandamos cada byte de prueba
		$display("Iniciando test de UART RX...");
		
		// Primer byte
		$display("Enviando dato: %h", test_data[0]);
		send_byte(test_data[0]);
		
		// Esperamos a que se active data_valid
		//wait(data_valid);
		$display("Recibido: %h, Esperado: %h, %s", 
			parallel_out, test_data[0], 
			(parallel_out == test_data[0]) ? "CORRECTO" : "ERROR");
		
		// Segundo byte
		$display("Enviando dato: %h", test_data[1]);
		send_byte(test_data[1]);
		
		// Esperamos a que se active data_valid
		//wait(data_valid);
		$display("Recibido: %h, Esperado: %h, %s", 
			parallel_out, test_data[1], 
			(parallel_out == test_data[1]) ? "CORRECTO" : "ERROR");
		
		// Tercer byte
		$display("Enviando dato: %h", test_data[2]);
		send_byte(test_data[2]);
		
		// Esperamos a que se active data_valid
		//wait(data_valid);
		$display("Recibido: %h, Esperado: %h, %s", 
			parallel_out, test_data[2], 
			(parallel_out == test_data[2]) ? "CORRECTO" : "ERROR");
		
		$display("Test completado!");
		#100 $stop;
	end
	
	// Monitor opcional: observar los cambios en las señales críticas
	initial begin
		$monitor("Time: %t, State: %d, Data: %h, Valid: %b", 
				$time, dut.active_state, parallel_out, data_valid);
	end

endmodule