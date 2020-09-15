const path = require('path');



function getFile(fileName) {
  return path.join(__dirname + '/html/' + fileName);
}

function respond(res, status, message) {
  return res.status(status).send({
    message: message
  });
}

exports.getFile = getFile;
exports.respond = respond;