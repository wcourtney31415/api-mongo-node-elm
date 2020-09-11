const {
  app
} = require('./app');

const {
  links
} = require('./links');

const path = require('path');



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

function getFile(fileName) {
  return path.join(__dirname + '/html/' + fileName);
}