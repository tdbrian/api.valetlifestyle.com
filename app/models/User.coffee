
# REQUIRES
# ////////////////////////////////////////////////////////////////////////////////////////

Mongoose = require("mongoose")

# Connect to DB
conn = Mongoose.connect 'mongodb://tdbrian:Timmy7201@ds043398.mongolab.com:43398/valet', (err) ->
    if err
        console.log 'User DB connection error!'

Schema = Mongoose.Schema

# Model Schema
UserSchema = new Schema
    authLevel: String
    clientOf: String
    companyAbbrev: String
    companyGeneralType: String
    companyID: Number
    companyName: String
    companySpecificType: String
    deleted: Boolean
    email: String
    firstName: String
    lastName: String
    loginHistory: Array
    mobilePhone: String
    officePhone: String
    password: String
    position: String
    userID: String
    username: String

# Setup Model
User = Mongoose.model 'users', UserSchema
module.exports = User