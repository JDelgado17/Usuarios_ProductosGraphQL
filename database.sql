CREATE DATABASE IF NOT EXISTS graphql_db
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE graphql_db;

-- ---------------------------------------------------------------
-- Tabla: users
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
('Ana Torres', 'ana@example.com'),
('Carlos Parra', 'carlos@example.com');

-- ---------------------------------------------------------------
-- Tabla: products (actividad de transferencia, seccion 14 de la guia)
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  description VARCHAR(255) NULL,
  price DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_price_positive CHECK (price > 0),
  CONSTRAINT chk_stock_no_negative CHECK (stock >= 0)
);

INSERT INTO products (name, description, price, stock) VALUES
('Teclado mecanico', 'Switches rojos, retroiluminado', 189000.00, 15),
('Mouse inalambrico', 'Sensor optico 1600 DPI', 65000.00, 30);

-- ---------------------------------------------------------------
-- Verificacion
-- ---------------------------------------------------------------
SELECT id, name, email FROM users;
SELECT id, name, description, price, stock FROM products;
