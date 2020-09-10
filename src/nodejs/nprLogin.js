const {
  app,
  jsonParser
} = require('./app');

const crypto = require('crypto');

const moment = require('moment');


const User = require('./schemas');

function respond(res, status, message) {
  return res.status(status).send({
    message: message
  });
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


function login(req, res) {
  const query = {
    email: req.body.email
  };
  User.findOne(query, (err, user) => {
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
  });
}

app.post('/login', jsonParser, login);