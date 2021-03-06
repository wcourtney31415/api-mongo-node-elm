const {
  app,
  jsonParser
} = require('./app');

const respond = require('./oddsAndEnds');

const User = require('./schemas');



function signUp(req, res) {
  let newUser = new User();
  newUser.name = req.body.name;
  newUser.email = req.body.email;
  newUser.setPassword(req.body.password);
  newUser.save(addUser(res));
}

function addUser(res, err, User) {
  if (err) {
    respond(res, 400, "Failed to add user.");
  } else {
    respond(res, 201, "User added successfully.");
  }
}

app.post('/signup', jsonParser, signUp);