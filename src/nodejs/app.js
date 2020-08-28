const express = require('express');
const bodyParser = require('body-parser');


const jsonParser = bodyParser.json();
const app = express();

exports.app = app;
exports.jsonParser = jsonParser;