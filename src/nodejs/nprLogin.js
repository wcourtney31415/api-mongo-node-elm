const {
  app,
  jsonParser
} = require('./app');

const {
  respond
} = require('./oddsAndEnds');

const crypto = require('crypto');

const moment = require('moment');

const User = require('./schemas');



function login(req, res) {
  const query = {
    email: req.body.email
  };
  const attemptLogin = (err, user) => {
    if (user) {
      const password = req.body.password;
      const passIsCorrect = user.validatePassword(password);
      if (passIsCorrect) {
        addSession(user);
        respond(res, 201, "User logged in.");
      } else {
        respond(res, 400, "Wrong Password.");
      }
    } else {
      respond(res, 400, "User not found.");
    }
  };
  User.findOne(query, attemptLogin);
}



function addSession(user) {
  const sessionId = crypto.randomBytes(16).toString('hex');
  const exp = moment().add(180, 'days').calendar();
  const sessionData = {
    sessionId: sessionId,
    exp: exp
  };
  user.sessions.push(sessionData);
  user.save();
}

app.post('/login', jsonParser, login);