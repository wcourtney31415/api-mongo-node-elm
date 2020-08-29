const {
  app,
  jsonParser
} = require('./app');
const {
  linkPostPeople
} = require('./links');
const {
  User
} = require('./schemas');


app.post(linkPostPeople, jsonParser, (request, response) => {
  body = request.body
  //Request Json field name, then query field name for mongo.
  const permittedFields = [
    ["firstName", "firstName"],
    ["lastName", "lastName"],
    ["email", "email"],
    ["phoneNumber", "phoneNumber"],
    ["birthdate", "birthdate"]
  ];
  const query = toPermittedFields(body, permittedFields);
  const desiredFields = 'firstName lastName birthdate';
  User.find(query, desiredFields, function(err, users) {
    if (err) return handleError(err);
    console.log(users);
    response.json(users);
  });
});

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