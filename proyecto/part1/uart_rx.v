module uart_rx #(
	// Parámetros configurables desde fuera
	parameter BASE_FREQ = 'd50_000_000,   // Frecuencia base por defecto (50 MHz)
	parameter BAUDRATE = 'd115_200        // Baudrate por defecto (115.2 kbps)
)(
	input clk,  
	input serial_in,
	input rst,
	output reg [7:0] parallel_out = 'b00000000,
);

localparam counts_per_bit = BASE_FREQ / BAUDRATE; // Cuántos ciclos de reloj por bit

// Estados de la máquina
localparam RX_IDLE = 3'b000;
localparam RX_START = 3'b001;
localparam RX_DATA = 3'b010; 
localparam RX_STOP = 3'b100;

// Registros internos


always @(posedge clk or posedge rst)
	if(rst) begin 

	end
	else begin
		case(active_state)
		RX_IDLE: begin  

		end
		
		RX_START: begin  

		end
					
		RX_DATA: begin

		end
		
		
		RX_STOP: begin

		end
		
		default: begin
			active_state <= RX_IDLE;  // Por seguridad, volvemos a IDLE
		end
		
		endcase
	end

endmodule