# Foundations: Bloqueo Temporal de Asientos

## Contexto
En eventos de alta demanda, múltiples usuarios intentan comprar los mismos asientos simultáneamente de forma masiva. Si el back-end no gestiona esto correctamente, se pueden producir ventas duplicadas (overbooking) sobre un mismo asiento, generando inconsistencias en los datos y frustración.

## Objetivos
- **Evitar sobreventas:** Garantizar mediante integridad de base de datos que dos personas no puedan reservar el mismo asiento al mismo tiempo.
- **Feedback en Tiempo Real:** Notificar visualmente a todos los clientes (ej: cambiar el asiento a gris) al instante en que otro cliente lo bloquea.
- **Liberación Automática (TTL):** Implementar un tiempo de vida máximo de 5 minutos para una reserva. Si no se completa el proceso de pago, el asiento se auto-libera para otros compradores.
- **Single Source of Truth:** Imponer que el cliente (frontend) sea tonto respecto a los estados; el servidor es la única entidad que decide el estado real de un asiento, rechazando peticiones que asuman estados inválidos.
