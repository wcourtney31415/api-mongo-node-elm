const {
  app
} = require('./app');
const {
  links
} = require('./links');


app.get('/', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
})

app.get('/login', (request, response) => {
  const homepage = getFile('html/Login.html');
  response.sendFile(homepage);
})

app.get('/signup', (request, response) => {
  const homepage = getFile('html/SignUp.html');
  response.sendFile(homepage);
})


function getFile(fileName) {
  return path.join(__dirname + '/' + fileName);
}