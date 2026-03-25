-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS ticket_platform;
USE ticket_platform;

-- Limpiar tablas si existen 
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS events;

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

-- Tabla de categorías
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL, -- Ej: 'VIP', 'General', 'Pista'
    price DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

-- Tabla de asientos
CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    category_id INT NOT NULL,
    row_number VARCHAR(10) NULL, -- Puede ser nulo si la categoría es de pie y solo se descuentan de un aforo
    seat_number VARCHAR(10) NULL,
    status ENUM('available', 'reserved', 'sold') DEFAULT 'available',
    session_id VARCHAR(255) NULL, -- ID de la sesión (del frontend/Socket.IO) del usuario actual que lo tiene reservado
    reserved_at TIMESTAMP NULL, -- Timestamp para manejar expiración de reservas si el usuario no concreta el pago
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE KEY unique_seat (event_id, category_id, row_number, seat_number)
);

-- Datos iniciales

-- Insertar evento de ejemplo
INSERT INTO events (id, title, description, event_date, location) VALUES
(1, 'Concierto Metrópolis 2026', 'El evento musical más esperado del año con tecnologías en tiempo real.', '2026-06-15 21:00:00', 'Estadio Central, Metrópolis');

-- Insertar categorías
INSERT INTO categories (id, event_id, name, price, capacity) VALUES
(1, 1, 'VIP', 150.00, 50),
(2, 1, 'Pista General', 60.00, 200),
(3, 1, 'Grada Sur', 45.00, 100);

-- Insertar asientos VIP (Zona VIP tiene filas y asientos)
INSERT INTO seats (event_id, category_id, row_number, seat_number, status) VALUES
(1, 1, 'V-A', '1', 'available'),
(1, 1, 'V-A', '2', 'available'),
(1, 1, 'V-A', '3', 'available'),
(1, 1, 'V-A', '4', 'available'),
(1, 1, 'V-A', '5', 'available'),
(1, 1, 'V-B', '1', 'available'),
(1, 1, 'V-B', '2', 'available'),
(1, 1, 'V-B', '3', 'available'),
(1, 1, 'V-B', '4', 'available'),
(1, 1, 'V-B', '5', 'available');

-- Insertar asientos Grada Sur (Simulando algunos ya vendidos o reservados)
INSERT INTO seats (event_id, category_id, row_number, seat_number, status) VALUES
(1, 3, 'G-1', '1', 'available'),
(1, 3, 'G-1', '2', 'sold'),
(1, 3, 'G-1', '3', 'sold'),
(1, 3, 'G-1', '4', 'reserved'),
(1, 3, 'G-1', '5', 'available');

-- Insertar Pista General (Suele ser sin asiento físico, pero creamos entradas nominales de cupo)
INSERT INTO seats (event_id, category_id, row_number, seat_number, status) VALUES
(1, 2, 'P-GEN', '1', 'available'),
(1, 2, 'P-GEN', '2', 'available'),
(1, 2, 'P-GEN', '3', 'available'),
(1, 2, 'P-GEN', '4', 'available'),
(1, 2, 'P-GEN', '5', 'available');
