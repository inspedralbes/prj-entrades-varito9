# Plan: Estrategia de Implementación Técnica (Laravel + Node.js)

## Arquitectura Híbrida
- **Laravel (API Backend Principal):** Es la fuente de la verdad para la base de datos (Transacciones SQL, Autenticación de Usuarios API).
- **Node.js (Microservicio WebSockets):** Servidor dedicado puramente a Socket.IO. Solo se encarga de repartir mensajes al cliente en tiempo real y conectarse con Nuxt.
- **Nuxt (Frontend Web):** Realiza llamadas HTTP REST a Laravel, pero se mantiene "suscrito" por Socket.IO al servidor de Node para cambios visuales.

## Fase 1: API Transaccional (Laravel PHP)
1. **Endpoint `POST /api/seats/reserve`**:
   - Inicia una Transacción SQL para evitar race conditions.
   - Ejecuta: `UPDATE seats SET status = 'reserved', session_id = ?, reserved_at = NOW() WHERE id = ? AND status = 'available'`.
   - Si se realiza con éxito, Laravel notifica asíncronamente al servidor Node.js (vía Redis Pub/Sub o llamada HTTP post-hook) informando el ID bloqueado.
   - Retorna un `200 OK` al frontend.

## Fase 2: Módulo WebSockets (Node.js + Socket.IO)
1. Construir un servidor Socket.IO liviano en Node.
2. Servirá como "Altavoz": escucha notificaciones internas desde Laravel.
3. Cuando Laravel notifica una reserva o liberación, el servidor Node.js lanza inmediatamente `io.emit('seat_updated', { seat_id, status: 'reserved' })` a todos los clientes (Nuxt) conectados.

## Fase 3: Mecanismo de Limpieza Automático (Laravel Schedule)
1. Generar un comando de consola `php artisan seats:release-expired`.
2. Lanzar una query: `UPDATE seats SET status = 'available', session_id = NULL, reserved_at = NULL WHERE status = 'reserved' AND reserved_at < NOW() - INTERVAL 5 MINUTE`.
3. Registrar este comando en `routes/console.php` (Laravel 11) o en el Kernel usando Task Scheduling: `->everyMinute()`.
4. El comando notificará al servidor Node para que emita la señal `status: 'available'` por cada ticket destrabado.

## Fase 4: Integración UI (Frontend - Nuxt & Pinia)
1. **Estado Compartido**: Guardar la lista de asientos en Pinia (`seats[]`).
2. **WebSockets (Escucha Activa)**: Conectar Nuxt con el puerto del servidor de Node. Cada alerta de `seat_updated` sobrescribe el asiento específico en Pinia para cambiar el color instantáneamente a gris.
3. **HTTP (Acción Proactiva)**: Cuando el usuario hace clic en el asiento, Pinia invoca a `axios`/`fetch` contra el endpoint **Laravel** `/api/seats/reserve`.
