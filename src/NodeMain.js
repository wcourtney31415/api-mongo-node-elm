const MongoClient = require('mongodb').MongoClient;
const express = require('express')
const path = require('path');
const bodyParser = require('body-parser');

const app = express()

const host = 'localhost'
const httpPort = 80
const address = `http://${host}:${httpPort}`

const mongoAddress = 'localhost'
const mongoPort = 27017
const mongoUrl = `mongodb://${mongoAddress}:${mongoPort}/`;
const dbName = "MyDb"
const myColName = "users"

const linkGetPeople = '/getShowPeople';
const linkNonDB = '/nonDatabaseRequest';
const linkPostPeople = '/postShowPeople';
const links = [linkGetPeople, linkNonDB, linkPostPeople]


app.use(bodyParser.urlencoded({
  extended: true
}));

app.get(linkGetPeople, (request, response) => {
  MongoClient.connect(mongoUrl, function(err, db) {
    if (err) throw err;
    const dbo = db.db(dbName);
    const collection = dbo.collection(myColName);
    const query = {
      lastName: "Green"
    };
    const queryResults = collection.find(query)
    queryResults.toArray(function(err, result) {
      if (err) throw err;
      response.send(result);
      db.close();
    });
  });
  logPageServed(linkGetPeople);
})

app.get(linkNonDB, (request, response) => {
  const jsonExample = {
    _id: "5f27882f5d389500061a6deb",
    firstName: "Celeste",
    lastName: "Green",
    phoneNumber: "(649) 366-4307",
    email: "interdum.libero.dui@sitamet.com",
    birthdate: "02-03-15",
    streetAddress: "P.O. Box 645, 3777 Vitae, Street",
    city: "Castel Maggiore",
    zip: "39417",
    country: "Mongolia"
  };
  response.json(jsonExample);
  logPageServed(linkNonDB);
})

app.get('/', (request, response) => {
  const homepage = getFile('index.html');
  response.sendFile(homepage);
  logPageServed("");
})

function getFile(fileName) {
  return path.join(__dirname + '/' + fileName)
}

function logPageServed(path) {
  const fullAddress = address + path
  console.log(`Served up: ${fullAddress}`);
}

app.post(linkPostPeople, (request, response) => {
  body = request.body
  token = parseInt(body.token)
  if (token === 5) {
    MongoClient.connect(mongoUrl, function(err, db) {
      if (err) throw err;
      const dbo = db.db(dbName);
      const collection = dbo.collection(myColName);
      const query = {
        lastName: request.body.lastName
      };
      const queryResults = collection.find(query)
      queryResults.toArray(function(err, result) {
        if (err) throw err;
        response.json(result);
        db.close();
      });
    });
  } else {
    response.json("[]");
  }
  logPageServed(linkPostPeople);
});

//Keeps the server listening
app.listen(httpPort, () => {
  startupMessage();
})

function startupMessage() {
  const msg = `Server Started: ${address}`
  console.log(msg)
  links.forEach(path => {
    fullPath = address + path;
    console.log(fullPath);
  });
  console.log("")
}