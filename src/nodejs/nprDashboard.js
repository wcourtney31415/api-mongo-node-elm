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
  const go = (err, user) => {
    if (user) {
      const sessions = user.sessions;
      const sessionId = req.body.sessionId;
      const validSession = checkSessionId(sessionId, sessions);
      if (validSession) {
        const path = 'Dashboard.html';
        const dashboardPage = getFile(path);
        res.sendFile(dashboardPage);
      } else {
        res.redirect("/login");
      }
    } else {
      //User not found
      res.redirect("/login");
    }
  };
  User.findOne(query, go);
}

function checkSessionId(sessionId, sessionList) {
  var validSession = false;
  sessionList.forEach(session => {
    if (sessionId == session.sessionId) {
      validSession = true;
    }
  });
  return validSession;
}

app.get('/dashboard', jsonParser, dashboard);