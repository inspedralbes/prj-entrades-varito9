# Spec: Comportamiento del Bloqueo de Asientos

## Escenarios de Uso

### 1. Bloqueo exitoso
- **Dado** que un asiento está en estado `available`.
- **Cuando** el usuario hace clic sobre él.
- **Entonces** el sistema muta su estado a `reserved`.
- **Y** el servidor asigna el `session_id` actual al asiento, junto a un `reserved_at` = *NOW()*.
- **Y** se emite un evento WebSocket `seat_updated` al resto de clientes para que bloqueen la UI de ese asiento.

### 2. Intento de bloqueo concurrente (Race Condition)
- **Dado** que un asiento está en estado `reserved` o `sold`.
- **Cuando** otro usuario intenta seleccionarlo.
- **Entonces** la transacción SQL falla por condición (el ticket ya cambió).
- **Y** el servidor responde con error de "Asiento ya no disponible".
- **Y** el frontend de este segundo usuario se actualiza para pintarlo de gris (sync forzado).

### 3. Expiración del bloqueo
- **Dado** que un asiento lleva más de 5 minutos en estado `reserved`.
- **Cuando** el servidor ejecuta su limpieza recurrente (cron job interno).
- **Entonces** el asiento vuelve al estado `available`.
- **Y** se limpian los campos `session_id` y `reserved_at`.
- **Y** se emite un evento `seat_updated` para destrabarlo en las vistas de los clientes.

### 4. Confirmación del pago
- **Dado** que un asiento está `reserved` y no ha expirado.
- **Cuando** su "dueño" (mismo `session_id`) efectúa el request de checkout final.
- **Entonces** el estado del asiento pasa a `sold`.
- **Y** se consolida en base de datos.
- **Y** se emite un evento `seat_updated` finalizando el proceso visual.
