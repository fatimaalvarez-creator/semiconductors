module uart_tx #(
	// Parámetros configurables desde fuera
	parameter BASE_FREQ = 'd50_000_000,   // Frecuencia base por defecto (50 MHz)
	parameter BAUDRATE = 'd115_200       // Baudrate por defecto (115.2 kbps)
)(
	input [7:0] data,
	input send_data,
	input clk,
	input rst,
	output reg serial_out
);
// Parámetros derivados (calculados automáticamente)
localparam counts_per_bit = BASE_FREQ / BAUDRATE; // Cuántos ciclos de reloj por bit

// Estados de la máquina, tres bits al menos para representarlo
localparam TX_IDLE = 3'b000;    
localparam TX_START = 3'b001;   // Mandamos el bit de inicio
localparam TX_DATA = 3'b010;    // Enviando los datos
localparam TX_PARITY = 3'b011;  // Bit de paridad para detectar errores
localparam TX_STOP = 3'b100;    // Bit de parada para terminar la transmisión

// Registros internos
reg [2:0] active_state =  0;     // Estado actual
reg [31:0] clock_ctr;       // Contador de ciclos de reloj
reg [2:0] d_idx;            // Índice del bit actual 
reg [3:0] bit_ctr;          // Contador de bits '1' para calcular paridad

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		// Reset asíncrono, volvemos a valores iniciales
		active_state <= TX_IDLE;
		serial_out <= 1;       // La línea debe estar en alto cuando está en reposo
		clock_ctr <= 0;
		d_idx <= 0;
		bit_ctr <= 0;
	end
	else
	begin
		case(active_state)
		TX_IDLE:
			begin
				// Estado de espera, todo en reposo
				serial_out <= 1;    // Línea en alto = inactiva
				clock_ctr <= 0;
				d_idx <= 0;
				bit_ctr <= 0;       // Reiniciamos contador de unos
				
				if(send_data)
					// Nos llegó la señal de enviar
					active_state <= TX_START;
				else
					active_state <= TX_IDLE; //si nada, se queda en este estado
			end
		
		TX_START:
			begin
				// Enviamos bit de inicio (siempre 0)
				serial_out <= 0;
				
				if(clock_ctr < counts_per_bit-1)
				begin
					// Esperamos el tiempo de un bit
					clock_ctr <= clock_ctr + 1;
					active_state <= TX_START;
				end
				else
				begin
					// Ya pasó el tiempo, vamos a los datos
					clock_ctr <= 0;
					active_state <= TX_DATA;
				end
			end
		
		TX_DATA:
			begin
				// Enviamos el bit actual de datos
				serial_out <= data[d_idx];
				
				// Seguimos esperando el tiempo de un bit
				if(clock_ctr < counts_per_bit-1)
				begin
					clock_ctr <= clock_ctr + 1;
					active_state <= TX_DATA;
				end
				//terminó el tiempo de transmisión del bit
				else
				begin
					//reseteo dle clock_ctr
					clock_ctr <= 0;
					
					// Actualizamos el contador de unos para la paridad
					if(data[d_idx] == 1)
						bit_ctr <= bit_ctr + 1;
					//si el índice es menor a 7 (inicia siendo 0 y el 7 es el último indice, 8 bits en total)
					//el cero no es el que hay en idle? sí pero no se manda hasta tx data.
					if(d_idx < 7)
					begin
						// Todavía quedan bits por enviar
						d_idx <= d_idx + 1;
						active_state <= TX_DATA;
					end
					else
					begin
						// Ya enviamos todos los bits, vamos a la paridad
						active_state <= TX_PARITY;
					end
				end
			end
		
		TX_PARITY:
			begin
				// Calculamos el bit de paridad ((pariddad par)
				if(bit_ctr % 2 == 0)
					serial_out <= 0;    // Paridad par: 0 si hay número par de unos
				else
					serial_out <= 1;    // 1 si hay número impar
				if(clock_ctr < counts_per_bit-1)
				begin
					// Esperamos el tiempo de un bit
					clock_ctr <= clock_ctr + 1;
					active_state <= TX_PARITY;
				end
				else
				begin
					// Ya pasó el tiempo para el bit de pariedad, ahora toca el de stop
					clock_ctr <= 0;
					active_state <= TX_STOP;
				end	
			end
		
		TX_STOP:
			begin
				// Enviamos bit de parada (siempre 1)
				serial_out <= 1;
				
				if(clock_ctr < counts_per_bit-1)
				begin
					// Esperamos el tiempo de un bit
					clock_ctr <= clock_ctr + 1;
					active_state <= TX_STOP;
				end
				else
				begin
					// Transmisión completa, volvemos a esperar
					clock_ctr <= 0;
					active_state <= TX_IDLE;
				end
			end
		endcase
	end
end
endmodule