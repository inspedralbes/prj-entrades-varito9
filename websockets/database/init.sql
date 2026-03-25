-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS ticket_platform;
USE ticket_platform;

-- Limpiar tablas si existen (orden inverso por dependencias)
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS users;

-- Tabla de usuarios (para ambas tecnologías: API y Websockets)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de eventos
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de asientos
CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    status ENUM('disponible', 'reservat', 'venut') DEFAULT 'disponible',
    user_id INT NULL, -- Relación con el usuario que tiene la reserva o la compra final
    session_id VARCHAR(255) NULL, -- ID de sesión (para reservar temporalmente sin estar logueado, opcional)
    reserved_at TIMESTAMP NULL, -- Timestamp para manejar expiración de reservas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_seat (event_id, seat_number)
);

-- ==============================================
-- DATOS INICIALES (SEEDER)
-- ==============================================

-- 1. Insertar usuarios (Passwords en hash genérico de Laravel/Bcrypt 'password' de ejemplo)
INSERT INTO users (name, email, password) VALUES
('Admin User', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
('Jane Doe', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
('John Smith', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- 2. Insertar eventos
INSERT INTO events (title, description, event_date, location) VALUES
('Concierto Metrópolis 2026', 'El evento musical más esperado del año', '2026-06-15 21:00:00', 'Estadio Central'),
('Obra de Teatro: La Ilusión', 'Drama clásico moderno', '2026-07-10 19:30:00', 'Teatro Principal');

-- 3. Insertar asientos para el Concierto (Evento 1)
INSERT INTO seats (event_id, seat_number, status, user_id) VALUES
(1, 'A1', 'venut', 2),
(1, 'A2', 'venut', 2),
(1, 'A3', 'reservat', 3),
(1, 'A4', 'disponible', NULL),
(1, 'A5', 'disponible', NULL),
(1, 'B1', 'disponible', NULL),
(1, 'B2', 'disponible', NULL),
(1, 'B3', 'disponible', NULL),
(1, 'B4', 'disponible', NULL),
(1, 'B5', 'disponible', NULL);

-- 4. Insertar asientos para el Teatro (Evento 2)
INSERT INTO seats (event_id, seat_number, status, user_id) VALUES
(2, 'F1', 'disponible', NULL),
(2, 'F2', 'disponible', NULL),
(2, 'F3', 'disponible', NULL),
(2, 'F4', 'disponible', NULL),
(2, 'F5', 'disponible', NULL);
