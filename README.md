# Usuarios y Productos GraphQL

Microservicio construido con **Node.js + Express + GraphQL + MySQL** que expone
un único endpoint (`/graphql`) para administrar **usuarios** (ejercicio base
de la guía) y **productos** (actividad de transferencia, sección 14).
Incluye una colección de **Postman** con las 10 operaciones CRUD y 6 pruebas
de error controladas.

## 1. Requisitos previos

- Node.js LTS y npm
- MySQL 8 (o compatible) en ejecución
- Postman Desktop o Web (con el Agente habilitado si usas la versión web)

## 2. Instalación

```bash
npm install
```

Esto instala `express`, `graphql`, `graphql-http`, `mysql2`, `dotenv`, `cors`
y, como dependencia de desarrollo, `nodemon`.

## 3. Base de datos

1. Abre MySQL Workbench, DBeaver o el cliente de línea de comandos.
2. Ejecuta el archivo `database.sql` completo (crea la base `graphql_db`,
   la tabla `users`, la tabla `products` y los datos de prueba).
3. Verifica que las dos consultas finales del script devuelvan filas.

> En ejecuciones posteriores, si vuelves a correr el script, comenta o
> elimina los bloques `INSERT` para no duplicar el correo de los usuarios.

## 4. Variables de entorno

Copia `.env.example` como `.env` y ajusta tus credenciales reales:

```bash
cp .env.example .env
```

```
PORT=4000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_clave
DB_NAME=graphql_db
```

`.env` está en `.gitignore`: **nunca subas contraseñas reales al repositorio**.
Solo se comparte `.env.example`.

## 5. Ejecución

```bash
npm run dev     # con recarga automática (nodemon)
# o
npm start        # ejecución simple
```

Si todo está bien configurado verás en consola:

```
Servicio en http://localhost:4000/graphql
```

Verifica primero el estado del servicio:

```
GET http://localhost:4000/health
```

Debe responder `{"status":"ok","service":"usuarios-productos-graphql"}`.

## 6. Estructura del proyecto

```
usuarios-productos-graphql/
├── src/
│   ├── config/db.js            # Pool de conexión MySQL
│   ├── graphql/schema.js       # Tipos, Query y Mutation (users + products)
│   ├── graphql/resolvers.js    # Lógica CRUD con SQL parametrizado
│   └── index.js                # Servidor Express y endpoint /graphql
├── .env                        # Variables reales (NO se sube al repo)
├── .env.example                # Plantilla sin credenciales reales
├── .gitignore
├── database.sql                # Script de creación de la base de datos
├── package.json
└── README.md
```

## 7. Operaciones disponibles

Todas se envían por `POST` a la **misma URL** `/graphql`; lo que cambia es
el contenido de `query` (y `variables`), no la ruta.

| Operación | Tipo | Descripción |
|---|---|---|
| `users` | Query | Lista todos los usuarios |
| `user(id)` | Query | Devuelve un usuario o `null` |
| `createUser(input)` | Mutation | Inserta y devuelve el usuario |
| `updateUser(id, input)` | Mutation | Actualiza y devuelve el usuario |
| `deleteUser(id)` | Mutation | Elimina y devuelve `{success, message}` |
| `products` | Query | Lista todos los productos |
| `product(id)` | Query | Devuelve un producto o `null` |
| `createProduct(input)` | Mutation | Inserta y devuelve el producto (precio > 0, stock ≥ 0) |
| `updateProduct(id, input)` | Mutation | Actualiza y devuelve el producto |
| `deleteProduct(id)` | Mutation | Elimina y devuelve `{success, message}` |

## 8. Pruebas en Postman

1. Importa `postman_collection.json` (Postman → *Import* → arrastra el archivo).
2. Revisa que la variable de colección `baseUrl` sea `http://localhost:4000`.
3. Ejecuta la carpeta **Usuarios** en orden: Listar → Buscar → Crear →
   Actualizar → Eliminar. El request "Crear" guarda automáticamente el `id`
   generado en la variable `userId` (mediante un test de Postman), que luego
   usan Actualizar y Eliminar.
4. Haz lo mismo con la carpeta **Productos** (usa la variable `productId`).
5. Revisa la carpeta **Casos negativos**: cada request está diseñado para
   fallar de forma controlada (correo duplicado, precio inválido, id
   inexistente, campo no definido en el esquema).
6. Para dejar evidencia: en cada pestaña de Postman, revisa la pestaña
   **Test Results** (deben quedar en verde) y toma una captura de pantalla
   de la petición + respuesta (`data`/`errors`) + resultados de los tests.

## 9. Errores comunes

| Síntoma | Causa | Acción |
|---|---|---|
| `ECONNREFUSED 3306` | MySQL detenido o puerto incorrecto | Inicia MySQL y revisa `DB_PORT` |
| `Access denied` | Credenciales incorrectas | Ajusta `.env` |
| `Unknown database 'graphql_db'` | No se ejecutó `database.sql` | Ejecuta el script |
| `Cannot find module` | Faltan dependencias | Ejecuta `npm install` |
| `Cannot query field` | El campo no existe en el esquema | Compara con `schema.js` |
| `Variable "$id" was not provided` | Falta variable obligatoria | Completa la pestaña *Variables* en Postman |
| `Duplicate entry` | Correo ya registrado | Usa otro correo |
| Puerto ocupado | Otro proceso usa el 4000 | Cambia `PORT` en `.env` o cierra el proceso |

## 10. Licencia

Uso académico — Tecnologías y Sistemas Web / Móvil.
