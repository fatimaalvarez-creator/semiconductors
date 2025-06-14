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
- `uart_rx_tb.v` → Prueba del receptor  
- `uart_top_tb.v` → Prueba del sistema completo

---

## ✅ Conclusiones

El diseño e implementación inicial del UART permite comprender de manera estructurada la lógica detrás de la transmisión asincrónica de datos. El uso de máquinas de estados facilita una arquitectura clara, escalable y verificable del sistema.

Este ejercicio refuerza la importancia de los UARTs en sistemas embebidos y sienta las bases para una implementación robusta en hardware real.

> *El UART no es solo una herramienta académica, sino un componente esencial en la comunicación digital moderna.*

---

## 📚 Referencias

- Documentación oficial del estándar RS-232  
- Apuntes y material del curso  
- Libros de diseño digital (VHDL y Verilog)  
- Recursos académicos sobre UART y FSMs  

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