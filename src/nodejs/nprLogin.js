const {
  app,
  jsonParser
} = require('./app');

const crypto = require('crypto');

const moment = require('moment');


const User = require('./schemas');



function login(req, res) {
  const query = {
    email: req.body.email
  };
  User.findOne(query, (err, user) => {
    if (user === null) {
      status = 400;
      message = "User not found.";
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
        status = 201;
        message = "User logged in.";
      } else {
        status = 400;
        message = "Wrong Password.";
      }
      return res.status(status).send({
        message: message
      });
    }
  });
}

app.post('/login', jsonParser, login);