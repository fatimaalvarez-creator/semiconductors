# Evidencia 2 - Parte 1  
## Comunicación serial asincrónica RS-232 y diseño de UART

---

## 📘 Introducción

Esta evidencia tiene como objetivo explorar los fundamentos y el diseño de un sistema de comunicación serial asincrónica utilizando el estándar RS-232, implementando un Receptor-Transmisor Asíncrono Universal (UART). Esta primera parte se centra en el análisis teórico, la comprensión técnica y el desarrollo inicial de los módulos UART mediante máquinas de estados finitos (FSM).

---

## 📌 Descripción del problema

El desafío consiste en implementar un sistema de transmisión y recepción de datos compatible con el estándar RS-232. Este protocolo transmite datos de 7 u 8 bits con detección de errores por paridad. Para lograr esto, es necesario comprender e implementar un UART que funcione correctamente a nivel digital, manejando tanto los estados del transmisor como del receptor.

---

## 🧠 Desarrollo de la propuesta de solución

1. **Investigación técnica**:
   - Estudio del funcionamiento del UART, incluyendo señales, registros y flujo de datos.
   - Análisis del estándar RS-232: niveles de voltaje, configuración de pines y estructura del paquete de datos.

2. **Diseño del UART**:
   - Implementación de FSMs para el módulo transmisor y el módulo receptor.
   - Descripción del comportamiento de cada estado en los FSMs.
   - Codificación en Verilog con estructuras claras y legibles.

3. **Buenas prácticas**:
   - Todo el código es original.
   - Comentarios y encabezados descriptivos en cada archivo.

---

## 🧪 Simulaciones

Se incluyen simulaciones de comportamiento que validan:
- La correcta transmisión de un byte con bit de inicio y final.
- La recepción sin errores de los datos transmitidos.
- La sincronización entre transmisor y receptor bajo condiciones ideales.

(Los resultados de simulación serán detallados en el informe escrito junto con capturas de pantalla y análisis de señales temporales.)

---

## ✅ Conclusiones

El diseño e implementación inicial del UART permite comprender de manera estructurada la lógica detrás de la transmisión asincrónica de datos. El uso de máquinas de estados facilita una arquitectura clara, escalable y verificable del sistema. Esta fase sienta las bases para una implementación robusta y funcional en hardware real.

---

## 📚 Referencias

- Documentación oficial del estándar RS-232.
- Apuntes y material de clase.
- Libros de texto sobre diseño digital con Verilog.
- Recursos académicos sobre UART y FSMs.

---

## 📎 Apéndice

El código fuente en Verilog se encuentra en los archivos adjuntos:  
`uart_tx.v`  
`uart_rx.v`
`uart_top.v`

---
