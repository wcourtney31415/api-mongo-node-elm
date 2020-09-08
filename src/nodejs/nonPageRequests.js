const {
  app,
  jsonParser
} = require('./app');

const crypto = require('crypto');

const {
  linkQueryUsers,
  linkCreateUser,
  linkDeleteUsers
} = require('./links');

const moment = require('moment');

const User = require('./schemas');



function toPermittedFields(json, jsonParser, permittedFields) {
  const query = {};
  permittedFields.forEach(tup => {
    const requestFieldName = tup[0];
    const queryFieldName = tup[1];
    const requestFieldValue = json[requestFieldName];
    if (requestFieldValue) {
      query[queryFieldName] = requestFieldValue;
    }
  });
  return query;
}

app.post('/login', jsonParser, (req, res) => {
  User.findOne({
    email: req.body.email
  }, function(err, user) {
    if (user === null) {
      return res.status(400).send({
        message: "User not found."
      });
    } else {
      if (user.validatePassword(req.body.password)) {

        const sessionId = crypto.randomBytes(16).toString('hex');
        const exp = moment().add(180, 'days').calendar();
        const sessionData = {
          sessionId: sessionId,
          exp: exp
        };

        user.sessions.push(sessionData);
        user.save();

        return res.status(201).send({
          message: "User Logged In",
        })
      } else {
        return res.status(400).send({
          message: "Wrong Password"
        });
      }
    }
  });
});

app.post('/signup', jsonParser, (req, res) => {
  const body = req.body;
  console.log(body);
  let newUser = new User();
  newUser.name = body.name
  newUser.email = body.email
  newUser.setPassword(body.password);
  newUser.save((err, User) => {
    if (err) {
      return res.status(400).send({
        message: "Failed to add user."
      });
    } else {
      return res.status(201).send({
        message: "User added successfully."
      });
    }
  });
});

app.post(linkQueryUsers, jsonParser, (request, response) => {
  const body = request.body;
  const myQuery = body.query;
  const email = body.email;
  const sessionId = body.session;

  const sessionQuery = {
    email: email,
    session: sessionId
  }

  User.find(sessionQuery, function(err, users) {
    if (err) response.json({
      error: "Query Failed."
    });
    if (users.length > 0) {
      console.log(email + " has successfully authenticated.");
      //Request Json field name, then query field name for mongo.
      const permittedFields = [
        ["firstName", "firstName"],
        ["lastName", "lastName"],
        ["email", "email"],
        ["phoneNumber", "phoneNumber"],
        ["birthdate", "birthdate"]
      ];
      const query = toPermittedFields(myQuery, permittedFields);
      const desiredFields = 'firstName lastName birthdate';
      User.find(query, desiredFields, function(err, users) {
        console.log(email + " performed query.");
        if (err) return handleError(err);
        response.json(users);
      });
    } else {
      response.json({
        error: "Failed to authenticate."
      })
    }


  });

});

app.post(linkDeleteUsers, jsonParser, (request, response) => {
  body = request.body
  //Request Json field name, then query field name for mongo.
  const permittedFields = [
    ["_id", "_id"]
  ];
  const query = toPermittedFields(body, permittedFields);
  const desiredFields = '';
  User.find(query, desiredFields).remove(function(err, users) {
    if (err) return handleError(err);
    console.log(users);
    response.json(users);
  });
});

app.post(linkCreateUser, jsonParser, (request, response) => {
  body = request.body
  //Request Json field name, then query field name for mongo.
  const permittedFields = [
    ["firstName", "firstName"],
    ["lastName", "lastName"],
    ["email", "email"],
    ["phoneNumber", "phoneNumber"],
    ["birthdate", "birthdate"]
  ];
  const newUser = new User(toPermittedFields(body, permittedFields));
  newUser.save(function(err) {
    response.send('Saved new user.');
  });
});