const MongoClient = require('mongodb').MongoClient;
const express = require('express')
const path = require('path');
const bodyParser = require('body-parser');

const app = express()
const jsonParser = bodyParser.json()

//Add timestamps to console logs.
require('console-stamp')(console, '[HH:MM:ss.l]');


//Webserver
const host = 'localhost'
const httpPort = 80
const address = `http://${host}:${httpPort}`

//MongoDB
const mongoAddress = 'localhost'
const mongoPort = 27017
const mongoUrl = `mongodb://${mongoAddress}:${mongoPort}/`;
const dbName = "MyDb"
const myColName = "users"

//Links
const linkPostPeople = '/findusers';
const links = [linkPostPeople]

app.get('/', (request, response) => {
  const homepage = getFile('index.html');
  response.sendFile(homepage);
  logPageServed("");
})

function searchWith(json) {
  console.log("");
  console.log("");
  console.log("");
  console.log("JSON accepted from Elm: ");
  console.log(json);
  const query = {};
  if (json.firstName !== "") {
    query.firstName = json.firstName;
  }
  if (json.lastName !== "") {
    query.lastName = json.lastName;
  }
  if (json.email !== "") {
    query.email = json.email;
  }
  if (json.phoneNumber !== "") {
    query.phoneNumber = json.phoneNumber;
  }
  console.log("");
  console.log("");
  console.log("");
  console.log("Query: ");
  console.log(query);
  return query;
}

app.post(linkPostPeople, jsonParser, (request, response) => {
  body = request.body
  MongoClient.connect(mongoUrl, function(err, db) {
    if (err) throw err;
    const dbo = db.db(dbName);
    const collection = dbo.collection(myColName);
    const query = searchWith(body);
    const queryResults = collection.find(query)
    queryResults.toArray(function(err, result) {
      if (err) throw err;
      response.json(result);
      console.log("");
      console.log("");
      console.log("");
      console.log("Final Result: ");
      console.log(result);
      db.close();
    });
  });
  logPageServed(linkPostPeople);
});

app.listen(httpPort, () => {
  startupMessage();
})

function getFile(fileName) {
  return path.join(__dirname + '/' + fileName)
}

function startupMessage() {
  const msg = `Server Started: ${address}`
  console.log(msg)
  links.forEach(path => {
    fullPath = address + path;
    console.log(fullPath);
  });
  console.log("")
}

function logPageServed(path) {
  const fullAddress = address + path
  console.log(`Served up: ${fullAddress}`);
}