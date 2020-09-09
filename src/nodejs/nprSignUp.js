const {
  app,
  jsonParser
} = require('./app');

const User = require('./schemas');



app.post('/signup', jsonParser, signUp);

function signUp(request, response) {
  const body = request.body;
  console.log(body);
  let newUser = new User();
  newUser.name = body.name;
  newUser.email = body.email;
  newUser.setPassword(body.password);
  newUser.save(addUser(response));
}

function addUser(response, err, User) {
  var status;
  var message;
  if (err) {
    status = 400;
    message = "Failed to add user.";
  } else {
    status = 201;
    message = "User added successfully.";
  }
  const messageObj = {
    message: message
  };
  return response.status(status).send(messageObj);
}