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

		end
		
		RX_START: begin  

		end
					
		RX_DATA: begin

		end
		
		RX_PARITY: begin

		end
		
		RX_STOP: begin

		end
		
		default: begin
			active_state <= RX_IDLE;  // Por seguridad, volvemos a IDLE
		end
		
		endcase
	end

endmodule