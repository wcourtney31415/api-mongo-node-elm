const {
  app,
  jsonParser
} = require('./app');
const {
  linkQueryUsers,
  linkCreateUser,
  linkDeleteUsers
} = require('./links');
const {
  User
} = require('./schemas');

function toPermittedFields(json, permittedFields) {
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

app.post(linkQueryUsers, jsonParser, (request, response) => {
  body = request.body;
  myQuery = body.query;
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
    if (err) return handleError(err);
    console.log(users);
    response.json(users);
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