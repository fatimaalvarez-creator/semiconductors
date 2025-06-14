# Evidencia 2 - Parte 1  
## Comunicación serial asincrónica RS-232 y diseño de UART

---

## 📘 Introducción

Esta evidencia tiene como objetivo el diseño de un sistema UART basado en el estándar RS-232 mediante una máquina de estados finitos (FSM) implementada en VHDL. Se busca comprender el funcionamiento de los transmisores y receptores asíncronos, los cuales permiten enviar y recibir datos de forma serial, utilizando bits de inicio, paridad y parada como métodos de sincronización y verificación.

---

## 📌 Descripción del problema

El desafío consiste en implementar un sistema de transmisión y recepción de datos compatible con el estándar RS-232. Este protocolo transmite datos de 7 u 8 bits con detección de errores por paridad. Para lograr esto, es necesario comprender e implementar un UART que funcione correctamente a nivel digital, manejando tanto los estados del transmisor como del receptor.

---

## 🧠 Desarrollo de la propuesta de solución

**Lenguaje:**  
- VHDL  

**Herramientas utilizadas:**  
- ModelSim / QuestaSim  
- EDAPlayground (https://edaplayground.com/)  

**Arquitectura:**  
- Máquina de Estados Finitos (FSM) para transmisor  
- Máquina de Estados Finitos (FSM) para receptor  

---

### 🚀 FSM del Transmisor UART (TX)

Este módulo se encarga de enviar datos en serie, paso por paso, usando los siguientes estados:

- `TX_IDLE`: Espera a que se active la transmisión (`tx_start = 1`)
- `TX_START`: Manda un bit de inicio (0 lógico)
- `TX_DATA`: Envía uno por uno los 8 bits del dato (`data_in`)
- `TX_PARITY`: Calcula y envía el bit de paridad (sirve para detectar errores)
- `TX_STOP`: Manda el bit de parada (1 lógico) para cerrar la transmisión

👉 Al finalizar la transmisión, la señal `tx_done` se pone en alto.

---

### 📥 FSM del Receptor UART (RX)

Este módulo escucha continuamente el pin `rx` esperando recibir datos. Sus estados son:

- `RX_IDLE`: Espera que llegue un 0 (bit de inicio)
- `RX_START`: Confirma que ese 0 es válido
- `RX_DATA`: Lee los 8 bits del dato recibido
- `RX_PARITY`: Verifica si el bit de paridad coincide
- `RX_STOP`: Comprueba si el bit final es un 1 (parada correcta)

👉 Cuando se completa la recepción, el dato se entrega por `data_out` y se activa la señal `rx_done`.

---

## 🧪 Simulaciones

Las simulaciones validan lo siguiente:

- La transmisión de un byte con sus bits de control correctamente ordenados.
- La recepción completa del dato transmitido sin errores.
- La correcta sincronización entre transmisor y receptor bajo condiciones ideales.

**Testbenches incluidos:**

- `uart_tx_tb.v` → Prueba del transmisor
  
  **Simulación de Tx**
  
  ![image](https://github.com/user-attachments/assets/79be2c47-d6be-4b37-a01b-1556a0d7bfd2)

  En la gráfica de simulación se observa que la transmisión UART se lleva a cabo correctamente. El módulo inicia la transmisión de tres datos secuenciales (0x55, 0xAA y 0x3C) mediante la señal `send_data`. Esta señal se activa brevemente para indicar que un nuevo byte debe ser enviado. Después, se mantiene en alto durante un ciclo de reloj. Esto es adecuado para iniciar el proceso de transmisión sin generar múltiples envíos por un mismo dato.
  
  El dato a transmitir (data[7:0]) se actualiza correctamente antes de cada envío. Se puede verificar que el valor de salida `serial_out` cambia de acuerdo con la trama UART correspondiente para cada byte. Las tramas incluyen el bit de inicio (`start bit`), los ocho bits de datos, el bit de paridad (impar en este caso), y el bit de parada (`stop bit`).

  El comportamiento interno del módulo también es coherente con el proceso de transmisión. El registro active_state muestra la evolución a través de los distintos estados del transmisor, desde reposo (`IDLE`), paso por `START`, `DATA, PARITY`, hasta llegar a `STOP`. Las señales auxiliares como `bit_ctr` y `d_idx` también reflejan el avance por cada bit del dato y la temporización interna por bit, respectivamente.

  Finalmente, la señal `serial_out` presenta las transiciones esperadas. Por ejemplo, para el primer dato enviado (0x55, patrón binario 01010101), se observa una oscilación coherente con los bits de datos, además del bit de paridad correcto y el correspondiente bit de parada, lo cual confirma visualmente que la transmisión es precisa.

- `uart_rx_tb.v` → Prueba del receptor  

   **Simulación de Rx**

   ![alt text](uart_rx_tb.png)

   En la gráfica de simulación se observa que la **recepción UART** se lleva a cabo correctamente. El módulo inicia en estado de reposo (`RX_IDLE = 1`) mientras espera la llegada de un bit de inicio. Al detectarse una transición baja en la señal `serial_in`, el receptor comienza el proceso de captura de datos.

   El dato recibido (`data[7:0]`) se va reconstruyendo bit a bit conforme avanza la recepción. El valor final capturado es `0x55` (01010101), el cual se refleja correctamente en la señal `parallel_out`. Al concluir la recepción del byte, se activa brevemente la señal `data_valid`, indicando que el dato es válido y puede ser procesado por la lógica posterior.

   El comportamiento interno del módulo es coherente con una recepción bien secuenciada. La señal `active_state` muestra la evolución a través de los distintos estados de la máquina receptora: desde reposo (`IDLE`), paso por `START`, captura de datos (`DATA`), verificación de paridad (`PARITY`) y finalización en `STOP`. Las señales auxiliares como `bit_ctr` y `d_idx` permiten observar el avance por cada bit recibido y su sincronización interna por reloj.

   Además, el bit de paridad también es recibido y evaluado correctamente (`parity = 1`), sin detectarse errores (`parity_error = 0`). Esto confirma que la verificación de integridad está funcionando como se espera. La señal `serial_in` presenta las transiciones esperadas durante todo el proceso, desde el bit de inicio hasta el bit de parada, validando visualmente la correcta decodificación de la trama UART.

- `uart_top_tb.v` → Prueba del sistema completo

   **Simulación de TOP**

---

## ✅ Conclusiones

El diseño e implementación inicial del UART permite comprender de manera estructurada la lógica detrás de la transmisión asincrónica de datos. El uso de máquinas de estados facilita una arquitectura clara, escalable y verificable del sistema.

Este ejercicio refuerza la importancia de los UARTs en sistemas embebidos y sienta las bases para una implementación robusta en hardware real.

> *El UART no es solo una herramienta académica, sino un componente esencial en la comunicación digital moderna.*

---

## 📚 Referencias en formato APA

* Brown, S. D., & Vranesic, Z. G. (2009). Fundamentals of Digital Logic with VHDL Design (3rd ed.). McGraw-Hill.

* Tocci, R. J., Widmer, N. S., & Moss, G. L. (2011). Sistemas digitales: principios y aplicaciones (11.ª ed.). Pearson Educación.

* Spiceworks. (s. f.). What is UART? Universal asynchronous receiver-transmitter. Spiceworks. Recuperado el 14 de junio de 2025, de https://www.spiceworks.com/tech/networking/articles/what-is-uart/ 

* IEEE Std 1076™-2008. (2009). IEEE Standard VHDL Language Reference Manual. Institute of Electrical and Electronics Engineers.

---

## 📎 Apéndice

El código fuente en Verilog se encuentra en los archivos adjuntos:  
`uart_tx.v`  
`uart_rx.v` </br>
`uart_top.v`

---

## 📂 Archivos incluidos

- `uart_tx.v` → Transmisor UART  
- `uart_rx.v` → Receptor UART  
- `uart_top.v` → Módulo superior que conecta TX y RX  
- `uart_tx_tb.v` → Testbench del transmisor  
- `uart_rx_tb.v` → Testbench del receptor  
- `uart_top_tb.v` → Testbench general

---
