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

app.post(linkPostPeople, jsonParser, (request, response) => {
  body = request.body
  MongoClient.connect(mongoUrl, function(err, db) {
    if (err) throw err;
    const dbo = db.db(dbName);
    const collection = dbo.collection(myColName);
    const providedLastName = body.lastName;
    const providedFirstName = body.firstName;
    const providedPhone = body.phone
    const query = {};
    if (providedFirstName !== "") {
      query.firstName = providedFirstName;
    }
    if (providedLastName !== "") {
      query.lastName = providedLastName;
    }
    const queryResults = collection.find(query)
    queryResults.toArray(function(err, result) {
      if (err) throw err;
      response.json(result);
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