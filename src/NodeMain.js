const MongoClient = require('mongodb').MongoClient;
const express = require('express')
const path = require('path');

const app = express()

const httpAddress = 'localhost'
const httpPort = 80
const link = `http://${httpAddress}:${httpPort}`

const mongoAddress = 'localhost'
const mongoPort = 27017
const mongoUrl = `mongodb://${mongoAddress}:${mongoPort}/`;
const dbName = "MyDb"
const myColName = "users"

app.get('/people', (req, res) => {
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
  console.log(`${link}/people accessed.`);
})

app.get('/test', (req, res) => {
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
  console.log(`${link}/test accessed.`);
})

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/index.html'));
  console.log(`${link}/test accessed.`);
})



//Keeps the server listening
app.listen(httpPort, () => {
  const msg = `Server Started: ${link}`
  console.log(msg)
})