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

const linkPeople = '/people';
const linkTest = '/test';
const linkThis = '/this';
const links = [linkPeople, linkTest, linkThis]



app.use(bodyParser.urlencoded({
  extended: true
}));

app.get(linkPeople, (req, res) => {
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
      res.send(result);
      db.close();
    });
  });
  console.log(`${address}/people accessed.`);
})

app.get(linkTest, (req, res) => {
  const myJson = {
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
  res.json(myJson);
  console.log(`${address}/test accessed.`);
})

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/index.html'));
  console.log(`${address}/test accessed.`);
})

const query = {
  lastName: "Green"
};

function dbQuery(dbUrl, dbName, colName, query) {
  MongoClient.connect(dbUrl, function(err, connection) {
    if (err) throw err;
    const database = connection.db(dbName);
    const collection = database.collection(colName);
    const queryResults = collection.find(query)
    queryResults.toArray(function(err, result) {
      if (err) throw err;
      console.log("Within the function: ".concat(result));
      return result;
      database.close();
    });
  });
}

app.post(linkThis, (request, response) => {
  body = request.body
  token = parseInt(body.token)
  var result;
  if (token === 5) {
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
        response.json(result);
        db.close();
      });
    });
  } else {
    response.json("[]");
  }
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