const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const UserSchema = new Schema({
  firstName: String,
  lastName: String
});
const User = mongoose.model('User', UserSchema);


exports.User = User;