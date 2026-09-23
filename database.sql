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
  age INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Si la tabla users ya existia (guia 3), agregar la columna age:
-- ALTER TABLE users ADD COLUMN age INT NULL AFTER email;
-- (npm run crear-bd la agrega automaticamente si hace falta)

INSERT IGNORE INTO users (name, email, age) VALUES
('Ana Torres', 'ana@example.com', 22),
('Carlos Parra', 'carlos@example.com', 25);

-- Edad para los registros iniciales que venian sin ella
UPDATE users SET age = 22 WHERE email = 'ana@example.com' AND age IS NULL;
UPDATE users SET age = 25 WHERE email = 'carlos@example.com' AND age IS NULL;

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

INSERT INTO products (name, description, price, stock)
SELECT 'Teclado mecanico', 'Switches rojos, retroiluminado', 189000.00, 15
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Teclado mecanico');

INSERT INTO products (name, description, price, stock)
SELECT 'Mouse inalambrico', 'Sensor optico 1600 DPI', 65000.00, 30
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Mouse inalambrico');

-- ---------------------------------------------------------------
-- Verificacion
-- ---------------------------------------------------------------
SELECT id, name, email, age FROM users;
SELECT id, name, description, price, stock FROM products;
