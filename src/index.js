require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { graphqlHTTP } = require('express-graphql');
const schema = require('./graphql/schema');
const rootValue = require('./graphql/resolvers');
const pool = require('./config/db');

const app = express();
const port = Number(process.env.PORT || 4000);

app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) =>
  res.json({ status: 'ok', service: 'usuarios-productos-graphql' })
);

// Endpoint GraphQL con GraphiQL habilitado para probar desde el navegador
app.use('/graphql', graphqlHTTP({
  schema,
  rootValue,
  graphiql: true
}));

async function start() {
  try {
    await pool.query('SELECT 1');
    app.listen(port, () =>
      console.log(`Servicio en http://localhost:${port}/graphql`)
    );
  } catch (error) {
    console.error('No fue posible conectar con MySQL:', error.message);
    process.exit(1);
  }
}

start();
