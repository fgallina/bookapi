exports.up = function(knex, Promise) {
  return Promise.all([
    knex.schema.createTable('book', function(table) {
      table.increments();
      table.string('slug').unique().notNullable();
      table.string('title').unique().notNullable();
      table.string('author').notNullable();
      table.string('publisher').notNullable().defaultTo("");
      table.timestamps(true, true);
    })
  ]);
};

exports.down = function(knex, Promise) {
  return Promise.all([
    knex.schema.dropTable('book')
  ]);
};
