const {
  app,
  jsonParser
} = require('./app');

const {
  respond,
  getFile
} = require('./oddsAndEnds');


const User = require('./schemas');



function dashboard(req, res) {
  const query = {
    email: req.body.email
  };
  User.findOne(query, (err, user) => {
    if (user) {
      const sessions = user.sessions;
      sessions.forEach(session => {
        var validSession = false;
        if (req.body.sessionId == session.sessionId) {
          validSession = true;
        }
        if (validSession) {
          const dashboard = getFile('Dashboard.html');
          res.sendFile(dashboard);
        } else {
          res.redirect("/login");
        }
      });
    } else {
      respond(res, 400, "User not found.");
    }
  });
}


app.get('/dashboard', jsonParser, dashboard);