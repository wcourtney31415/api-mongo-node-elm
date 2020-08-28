const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

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

const UserSchema = new Schema({
  firstName: String,
  lastName: String
});

const User = mongoose.model('User', UserSchema);

//Links
const linkPostPeople = '/findusers';
const links = [linkPostPeople];

app.get('/', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
  logPageServed("login");
})

app.get('/login', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
  logPageServed("login");
})

app.get('/signup', (request, response) => {
  const homepage = getFile('html/SignUp.html');
  response.sendFile(homepage);
  logPageServed("signup");
})

function customPrint(title, value) {
  console.log("");
  console.log("");
  console.log("");
  console.log(`${title}: `);
  console.log(value);
}

//Request Json field name, then query field name for mongo.
const acceptedFieldList = [
  ["firstName", "firstName"],
  ["lastName", "lastName"],
  ["email", "email"],
  ["phoneNumber", "phoneNumber"],
  ["birthdate", "birthdate]"]
];

function requestToQuery(json, acceptedFieldList) {
  const query = {};
  acceptedFieldList.forEach(tup => {
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

app.post(linkPostPeople, jsonParser, (request, response) => {
  body = request.body
  const query = requestToQuery(body, acceptedFieldList);
  const desiredFields = 'firstName lastName';
  User.find(query, desiredFields, function(err, users) {
    if (err) return handleError(err);
    console.log(users);
    response.json(users);
  });
  logPageServed(linkPostPeople);
});

app.listen(httpPort, () => {
  startupMessage();
})

function getFile(fileName) {
  return path.join(__dirname + '/' + fileName);
}

function startupMessage() {
  const msg = `Server Started: ${address}`;
  console.log(msg);
  links.forEach(path => {
    fullPath = address + path;
    console.log(fullPath);
  });
  console.log("");
}

function logPageServed(path) {
  const fullAddress = address + path;
  console.log(`Served up: ${fullAddress}`);
}