const express = require('express');
const mongoose = require('mongoose');
const path = require('path');
const pages = require('./pages');
const nonPageRequests = require('./nonPageRequests');
const {
  links
} = require('./links');
const {
  app
} = require('./app');


//Add timestamps to console logs.
require('console-stamp')(console, '[HH:MM:ss.l]');

//Webserver Settings
const host = 'localhost';
const httpPort = 80;
const address = `http://${host}:${httpPort}`;

//Mongoose Settings
const hostname = 'localhost';
const port = '27017';
const dbName = 'MyDb';
const connectionString = `mongodb://${hostname}:${port}/${dbName}`;

mongoose.connect(connectionString, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

function startupMessage() {
  const msg = `Server Started: ${address}`;
  console.log(msg);
  links.forEach(path => {
    fullPath = address + path;
    console.log(fullPath);
  });
  console.log("");
}

app.listen(httpPort, () => {
  startupMessage();
})