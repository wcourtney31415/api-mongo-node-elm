const {
  app,
  jsonParser
} = require('./app');

const crypto = require('crypto');

const moment = require('moment');


const User = require('./schemas');



function loginWithEmail(req, err, user) {
  const password = req.body.password;
  var message;
  var status;
  if (user === null) {
    message = "User not found.";
    status = 400;
  } else {
    const passwordIsCorrect = user.validatePassword(password);
    if (passwordIsCorrect) {
      const sessionId = crypto.randomBytes(16).toString('hex');
      const expiration = moment().add(180, 'days').calendar();
      const sessionData = {
        sessionId: sessionId,
        exp: expiration
      };
      user.sessions.push(sessionData);
      user.save();
      message = "User logged in.";
      status = 201;
    } else {
      message = "Wrong Password";
      status = 400;
    }
  }
  const messageObj = {
    message: message
  };
  return res.status(status).send(messageObj);
}

function login(req, res) {
  const query = {
    email: req.body.email
  };
  User.findOne(query, loginWithEmail(req));
}

app.post('/login', jsonParser, login);