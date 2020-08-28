const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Server Config: Begin ////////////////////////////////////////////////////////

const app = express();
const jsonParser = bodyParser.json();

//Add timestamps to console logs.
require('console-stamp')(console, '[HH:MM:ss.l]');


//Webserver
const host = 'localhost';
const httpPort = 80;
const address = `http://${host}:${httpPort}`;

//Mongoose
const hostname = 'localhost';
const port = '27017';
const dbName = 'MyDb';
const connectionString = `mongodb://${hostname}:${port}/${dbName}`;
mongoose.connect(connectionString, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Server Config: End //////////////////////////////////////////////////////////


// Mongoose Schemas: Begin /////////////////////////////////////////////////////

const UserSchema = new Schema({
  firstName: String,
  lastName: String
});
const User = mongoose.model('User', UserSchema);

// Mongoose Schemas: End ///////////////////////////////////////////////////////


// Server Initialization: Begin ////////////////////////////////////////////////

const linkPostPeople = '/findusers';
const links = [linkPostPeople];

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

// Server Initialization: End //////////////////////////////////////////////////


// Non-Page Requests: Begin ////////////////////////////////////////////////////

app.post(linkPostPeople, jsonParser, (request, response) => {
  body = request.body
  //Request Json field name, then query field name for mongo.
  const permittedFields = [
    ["firstName", "firstName"],
    ["lastName", "lastName"],
    ["email", "email"],
    ["phoneNumber", "phoneNumber"],
    ["birthdate", "birthdate]"]
  ];
  const query = requestedFieldsToQuery(body, permittedFields);
  const desiredFields = 'firstName lastName';
  User.find(query, desiredFields, function(err, users) {
    if (err) return handleError(err);
    console.log(users);
    response.json(users);
  });
});

// Related Utilities ///

function requestedFieldsToQuery(json, permittedFields) {
  const query = {};
  permittedFields.forEach(tup => {
    const requestFieldName = tup[0];
    const queryFieldName = tup[1];
    const requestFieldValue = json[requestFieldName];
    if (requestFieldValue) {
      query[queryFieldName] = requestFieldValue;
    }
  });
  console.log(query);
  return query;
}

// Non-Page Requests: End //////////////////////////////////////////////////////


// PAGES: Begin ////////////////////////////////////////////////////////////////

app.get('/', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
})

app.get('/login', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
})

app.get('/signup', (request, response) => {
  const homepage = getFile('html/SignUp.html');
  response.sendFile(homepage);
})

// Related Utilities ///

function getFile(fileName) {
  return path.join(__dirname + '/' + fileName);
}

// PAGES: End //////////////////////////////////////////////////////////////////