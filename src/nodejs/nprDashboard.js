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
      var validSession = false;
      sessions.forEach(session => {
        if (req.body.sessionId == session.sessionId) {
          validSession = true;
        }
      });
      if (validSession) {
        const dashboardPage = getFile('Dashboard.html');
        res.sendFile(dashboardPage);
      } else {
        res.redirect("/login");
      }
    } else {
      //User not found
      res.redirect("/login");
    }
  });
}


app.get('/dashboard', jsonParser, dashboard);