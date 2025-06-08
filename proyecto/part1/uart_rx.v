module uart_rx #(
	// Parámetros configurables desde fuera
	parameter BASE_FREQ = 'd50_000_000,   // Frecuencia base por defecto (50 MHz)
	parameter BAUDRATE = 'd115_200        // Baudrate por defecto (115.2 kbps)
)(
	input clk,  
	input serial_in,
	input rst,
	output reg [7:0] parallel_out = 'b00000000,
	output reg data_valid               // Nueva señal que indica cuando los datos son válidos
);

localparam counts_per_bit = BASE_FREQ / BAUDRATE; // Cuántos ciclos de reloj por bit

// Estados de la máquina
localparam RX_IDLE = 3'b000;
localparam RX_START = 3'b001;
localparam RX_DATA = 3'b010;
localparam RX_PARITY = 3'b011;  
localparam RX_STOP = 3'b100;

// Registros internos
//active or current state of the FSM is initialized to RX_IDLE
reg [2:0] active_state = RX_IDLE;
//clock counter to count the number of clock cycles, recieves new bit every counts_per_bit cycles (baudrate)
reg [31:0] clock_ctr = 0;
//shift register to store the index of the bit being received
reg [2:0] d_idx = 0;
//shift register to count the number of 1 bits received (for parity check)
reg [3:0] bit_ctr = 0;         // Contador de bits '1' para verificar paridad
reg parity_error = 0;          // Indica si hubo error de paridad

always @(posedge clk or posedge rst)
	if(rst) begin
		active_state <= RX_IDLE;
		clock_ctr <= 0;
		d_idx <= 0;
		bit_ctr <= 0;
		data_valid <= 0;
		parity_error <= 0;
	end
	else begin
		case(active_state)
		RX_IDLE: begin  
			clock_ctr <= 0;  
			d_idx <= 0;
			bit_ctr <= 0;
			//data_valid <= 0;      // Reseteamos la señal de datos válidos
			
			if(serial_in == 0)    // Detectamos el bit de inicio (siempre 0)
			begin
				active_state <= RX_START;
				data_valid <= 0;      // Reseteamos la señal de datos válidos
			end

			else	
				active_state <= RX_IDLE;

		end
		
		RX_START: begin  
			// Esperamos hasta la mitad del bit para muestrear en el centro
			if(clock_ctr < (counts_per_bit - 1)/2) begin
				clock_ctr <= clock_ctr + 1;  
				active_state <= RX_START;
			end
			//ya se cumplió medio periodo de bit, va hacia el estado donde lee los bits
			else begin
				active_state <= RX_DATA;
				clock_ctr <= 0;
			end
		end
					
		RX_DATA: begin
			// En datos, esperamos un bit completo antes de muestrear
			//estaba en el bit de inicio, ese no hay que leerlo
			if (clock_ctr < counts_per_bit - 1) begin  
				clock_ctr <= clock_ctr + 1;
				active_state <= RX_DATA;
			end
			//resetea el clock y mete el bit en el índice correspondiente
			else begin
				clock_ctr <= 0;
				parallel_out[d_idx] <= serial_in;  // Almacenamos el bit recibido
				
				// Actualizamos contador de unos para paridad
				if(serial_in == 1)
					bit_ctr <= bit_ctr + 1;
				//si se llega indice 6 (último caso valido), el indice se actualiza a 7 (8tavo bit)
				if(d_idx < 7) begin
					d_idx <= d_idx + 1;  
					active_state <= RX_DATA;  
				end
				else begin
					// Ya recibimos todos los bits de datos, ahora vamos por el de paridad
					active_state <= RX_PARITY;
				end
			end
		end
		
		RX_PARITY: begin
			// Verificamos el bit de paridad
			if(clock_ctr < counts_per_bit - 1) begin
				clock_ctr <= clock_ctr + 1;
				active_state <= RX_PARITY;
			end
			else begin
				clock_ctr <= 0;
				// Verificación de paridad par (mismo método que en TX)
				//si son bits pares pero se manda bit de pariedad o visceversa, hay error
				parity_error <= ((bit_ctr % 2 == 0) && serial_in == 1) || 
				               ((bit_ctr % 2 == 1) && serial_in == 0);
				active_state <= RX_STOP;
			end
		end
		
		RX_STOP: begin
			if(clock_ctr < counts_per_bit - 1) begin
				clock_ctr <= clock_ctr + 1;
				active_state <= RX_STOP;
			end
			else begin
				clock_ctr <= 0;
				// Si el bit de parada es 1 y no hubo error de paridad, datos válidos
				if(serial_in == 1 && !parity_error)
					data_valid <= 1;  // Indicamos que tenemos datos válidos
				else 
					data_valid <= 0; //si por alguna razon no llega un 1 en tx/rx stop, o hubo error en el parity check, la data no es valida
				active_state <= RX_IDLE;
			end
		end
		
		default: begin
			active_state <= RX_IDLE;  // Por seguridad, volvemos a IDLE
		end
		
		endcase
	end

endmodule