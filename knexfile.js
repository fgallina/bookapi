module.exports = {
  client: 'pg',
  connection: {
    host : process.env.PG_HOST || 'postgres',
    port : process.env.PG_PORT || 5432,
    user : process.env.PG_USER || 'postgres',
    password : process.env.PG_PASSWORD || 'password',
    database : process.env.PG_DATABASE || 'bookapi',
    charset  : 'utf8'
  }
};
