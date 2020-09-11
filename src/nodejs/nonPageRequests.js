const {
  app,
  jsonParser
} = require('./app');

const nprSignUp = require('./nprSignUp');

const nprLogin = require('./nprLogin');

const {
  linkQueryUsers,
  linkCreateUser,
  linkDeleteUsers
} = require('./links');

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