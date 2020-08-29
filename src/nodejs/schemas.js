const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const UserSchema = new Schema({
  firstName: String,
  lastName: String,
  email: String,
  phoneNumber: String,
  birthdate: String
});
const User = mongoose.model('User', UserSchema);


exports.User = User;