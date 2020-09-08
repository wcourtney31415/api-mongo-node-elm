const {
  app,
  jsonParser
} = require('./app');

const crypto = require('crypto');

const moment = require('moment');


const User = require('./schemas');



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