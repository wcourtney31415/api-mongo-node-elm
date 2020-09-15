const {
  app
} = require('./app');

const {
  getFile
} = require('./oddsAndEnds');

const {
  links
} = require('./links');



app.get('/', (request, response) => {
  const homepage = getFile('Login.html');
  response.sendFile(homepage);
})

app.get('/login', (request, response) => {
  const homepage = getFile('Login.html');
  response.sendFile(homepage);
})

app.get('/signup', (request, response) => {
  const homepage = getFile('SignUp.html');
  response.sendFile(homepage);
})