# Historial de Prompts - Spec-Driven Development

A continuación se documentan los prompts originarios volcados en esta etapa de planificación para poder auditar las directrices en el futuro.

## 2026-03-25 - Planificación del sistema asíncrono y bases de datos

**Prompt 1 (Base de Datos):**
> Diseño de la Base de Datos (MySQL) Dado que vas a combinar dos tecnologías diferentes en el backend, el primer paso indiscutible es crear una base de datos compartida y consistente a la que ambos sistemas puedan acceder. Redacta el script SQL de creación y los datos iniciales (entregable obligatorio). Define las tablas para eventos, asientos (disponible, reservado, venut) y usuarios. Esta base de datos será tu única fuente de la verdad.

**Prompt 2 (Estructura de Specs):**
> 2. Planificación con Spec-Driven Development (OpenSpec) Antes de programar la comunicación entre Laravel y Node.js, utiliza la Inteligencia Artificial para planificar una funcionalidad acotada (por ejemplo, el flujo de bloqueo temporal de un asiento). Redacta los archivos foundations.md, spec.md y plan.md. Define cómo Laravel va a validar la reserva y cómo Node.js se enterará de esto para avisar a los clientes. Guarda todos los prompts que uses en el archivo /docs/prompts-log.md para cumplir con la trazabilidad.
