const mongoose = require('mongoose');
const crypto = require('crypto');


const UserSchema = mongoose.Schema({
  firstName: String,
  lastName: String,
  email: String,
  phoneNumber: String,
  birthdate: String,
  salt: String,
  hash: String,
  sessions: [{
    sessionId: String,
    exp: String
  }]
});

UserSchema.methods.setPassword = function(password) {
  this.salt = crypto.randomBytes(16).toString('hex');
  this.hash = crypto.pbkdf2Sync(password, this.salt, 1000, 64, `sha512`).toString(`hex`);
};

UserSchema.methods.validatePassword = function(password) {
  const hash = crypto.pbkdf2Sync(password, this.salt, 1000, 64, `sha512`).toString(`hex`);
  return this.hash === hash;
};

const User = module.exports = mongoose.model('User', UserSchema);