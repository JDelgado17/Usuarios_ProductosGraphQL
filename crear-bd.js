// Ejecuta database.sql desde Node (útil cuando no se tiene Workbench o phpMyAdmin)
require('dotenv').config();
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

async function crearBaseDeDatos() {
  const conexion = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    multipleStatements: true
  });

  // Si la tabla users viene de la guía 3 y no tiene la columna age, se agrega
  const [tabla] = await conexion.query(
    "SELECT COUNT(*) AS existe FROM information_schema.TABLES WHERE TABLE_SCHEMA = ? AND TABLE_NAME = 'users'",
    [process.env.DB_NAME]
  );
  if (tabla[0].existe) {
    const [columna] = await conexion.query(
      "SELECT COUNT(*) AS existe FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = ? AND TABLE_NAME = 'users' AND COLUMN_NAME = 'age'",
      [process.env.DB_NAME]
    );
    if (!columna[0].existe) {
      await conexion.query(`ALTER TABLE ${process.env.DB_NAME}.users ADD COLUMN age INT NULL AFTER email`);
      console.log('Columna age agregada a la tabla users');
    }
  }

  const script = fs.readFileSync(path.join(__dirname, 'database.sql'), 'utf8');
  const resultados = await conexion.query(script);
  const tablas = resultados[0].filter(Array.isArray).slice(-2);

  console.log('Base de datos graphql_db lista\n');
  console.log('users');
  console.table(tablas[0]);
  console.log('products');
  console.table(tablas[1]);
  await conexion.end();
}

crearBaseDeDatos().catch((error) => {
  console.error('No se pudo crear la base de datos:', error.message);
});
