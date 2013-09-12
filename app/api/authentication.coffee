
# Valet Lifestyle 
# 
# @author     Thomas Brian  <tdbrian@gmail.com>
# @created    Sept 12, 2013
# 

# Requires
# ////////////////////////////////////////////////////////////////////////////////////////

User = require '../models/User'
Crypto = require 'crypto'
MongoClient = require('mongodb').MongoClient

# Private Functions
# ////////////////////////////////////////////////////////////////////////////////////////

connectDB = (res, req, cb) ->
    res.type 'text/json' 
    
    connect = "mongodb://tdbrian:Timmy7201@ds043398.mongolab.com:43398/valet" 
    MongoClient.connect connect, (err, db) ->
        
        if err
            res.send '{"status": "Error Mongo connecting to DB"}'
            db.close()
        cb(db)

# Public Functions
# ////////////////////////////////////////////////////////////////////////////////////////

# Validates user based on username and password
exports.createUser = (req, res) ->

    connectDB res, req, (db) ->

        console.log req.body

        req.body.password = Crypto.createHash('md5').update(req.body.password).digest("hex")

        collection = db.collection 'users'
        collection.save req.body, {w: 1}, (err, result) ->
            if err
                res.send "{status: 'Error Mongo connecting to Collection: users.'}"

            if result
                res.send {"status": "successful"}

            db.close()

## ------------------------------------------------------------------------
#
# Validates user based on username and password
exports.userLoginRequest = (req, res) ->

    hash = Crypto.createHash('md5').update(req.params.password).digest("hex")

    User.findOne {username: req.params.username}, (err, user) ->
        res.type 'text/plain' 
        if user?
            if hash is user.password
                user.status = 'passed'
                res.send user
            else
                res.send '{"status": "failed"}'
        else
            res.send '{"status": "failed"}'

## ------------------------------------------------------------------------

# Validates user based on userID
exports.userIdAuthentication = (req, res) ->

    User.findOne {userID: req.params.userID}, (err, user) ->
        
        res.type 'text/plain' 
        if user?
            user.status = 'passed'
            res.send user
        else
            res.send '{"status": "failed"}'

## ------------------------------------------------------------------------
