'use strict';

var express = require('express'),
    app = express(),
    port = process.env.PORT || 3000,
    db  = require('./db'),
    bodyParser = require('body-parser');

app.use(bodyParser.json());

var routes = require('./routes');
routes(app);
app.listen(port);

console.log('RESTful API server started on: ' + port);
