'use strict';

module.exports = function(app) {
  var handlers = require('./handlers');
  app.route('/books')
    .get(handlers.list)
    .post(handlers.create);
  app.route('/books/:slug')
    .get(handlers.read)
    .put(handlers.update)
    .delete(handlers.delete);
};
