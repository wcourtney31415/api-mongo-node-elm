const {
  app,
  jsonParser
} = require('./app');

const User = require('./schemas');


app.post('/signup', jsonParser, (req, res) => {
  const body = req.body;
  console.log(body);
  let newUser = new User();
  newUser.name = body.name
  newUser.email = body.email
  newUser.setPassword(body.password);
  newUser.save((err, User) => {
    if (err) {
      return res.status(400).send({
        message: "Failed to add user."
      });
    } else {
      return res.status(201).send({
        message: "User added successfully."
      });
    }
  });
});