var $$___app_models_User = {};
$$___app_models_User = (function(module, exports) {
  var Mongoose, Schema, User, UserSchema, conn;

Mongoose = require("mongoose");

conn = Mongoose.connect('mongodb://tdbrian:Timmy7201@ds043398.mongolab.com:43398/valet', function(err) {
  if (err) {
    return console.log('User DB connection error!');
  }
});

Schema = Mongoose.Schema;

UserSchema = new Schema({
  authLevel: String,
  clientOf: String,
  companyAbbrev: String,
  companyGeneralType: String,
  companyID: Number,
  companyName: String,
  companySpecificType: String,
  deleted: Boolean,
  email: String,
  firstName: String,
  lastName: String,
  loginHistory: Array,
  mobilePhone: String,
  officePhone: String,
  password: String,
  position: String,
  userID: String,
  username: String
});

User = Mongoose.model('users', UserSchema);

module.exports = User;

  return module.exports;
})({exports: $$___app_models_User}, $$___app_models_User);var $$___app_api_authentication = {};
$$___app_api_authentication = (function(module, exports) {
  var Crypto, MongoClient, User, connectDB;

User = $$___app_models_User;

Crypto = require('crypto');

MongoClient = require('mongodb').MongoClient;

connectDB = function(res, req, cb) {
  var connect;
  res.type('text/json');
  connect = "mongodb://tdbrian:Timmy7201@ds043398.mongolab.com:43398/valet";
  return MongoClient.connect(connect, function(err, db) {
    if (err) {
      res.send('{"status": "Error Mongo connecting to DB"}');
      db.close();
    }
    return cb(db);
  });
};

exports.createUser = function(req, res) {
  return connectDB(res, req, function(db) {
    var collection;
    console.log(req.body);
    req.body.password = Crypto.createHash('md5').update(req.body.password).digest("hex");
    collection = db.collection('users');
    return collection.save(req.body, {
      w: 1
    }, function(err, result) {
      if (err) {
        res.send("{status: 'Error Mongo connecting to Collection: users.'}");
      }
      if (result) {
        res.send({
          "status": "successful"
        });
      }
      return db.close();
    });
  });
};

exports.userLoginRequest = function(req, res) {
  var hash;
  hash = Crypto.createHash('md5').update(req.params.password).digest("hex");
  return User.findOne({
    username: req.params.username
  }, function(err, user) {
    res.type('text/plain');
    if (user != null) {
      if (hash === user.password) {
        user.status = 'passed';
        return res.send(user);
      } else {
        return res.send('{"status": "failed"}');
      }
    } else {
      return res.send('{"status": "failed"}');
    }
  });
};

exports.userIdAuthentication = function(req, res) {
  return User.findOne({
    userID: req.params.userID
  }, function(err, user) {
    res.type('text/plain');
    if (user != null) {
      user.status = 'passed';
      return res.send(user);
    } else {
      return res.send('{"status": "failed"}');
    }
  });
};

  return module.exports;
})({exports: $$___app_api_authentication}, $$___app_api_authentication);var $$___app_api_valetOpen = {};
$$___app_api_valetOpen = (function(module, exports) {
  var MongoClient, connectDB;

MongoClient = require('mongodb').MongoClient;

connectDB = function(res, req, cb) {
  var connect;
  res.type('text/json');
  connect = "mongodb://tdbrian:Timmy7201@ds043398.mongolab.com:43398/valet";
  return MongoClient.connect(connect, function(err, db) {
    if (err) {
      res.send('{"status": "Error Mongo connecting to DB"}');
      db.close();
    }
    return cb(db);
  });
};

exports.getGroup = function(req, res) {
  var id, idField;
  idField = req.params.idField;
  id = req.params.id;
  return connectDB(res, req, function(db) {
    var collection, query;
    query = {};
    query[idField] = id;
    query['deleted'] = false;
    collection = db.collection(req.params.collection);
    return collection.find(query).toArray(function(err, results) {
      if (err) {
        res.send('{status: "Error Mongo connecting to Collection: #{req.params.collection}."}');
      }
      if (results) {
        res.send(results);
      }
      return db.close();
    });
  });
};

exports.getItem = function(req, res) {
  var id, idField;
  idField = req.params.idField;
  id = req.params.id;
  return connectDB(res, req, function(db) {
    var collection, query;
    query = {};
    query[idField] = id;
    query['deleted'] = false;
    collection = db.collection(req.params.collection);
    return collection.findOne(query, function(err, results) {
      if (err) {
        res.send('{status: "Error Mongo connecting to Collection: #{req.params.collection}."}');
      }
      if (results) {
        res.send(results);
      }
      return db.close();
    });
  });
};

exports.insert = function(req, res) {
  return connectDB(res, req, function(db) {
    var collection;
    collection = db.collection(req.params.collection);
    return collection.save(req.body, {
      w: 1
    }, function(err, result) {
      if (err) {
        res.send("{status: 'Error Mongo connecting to Collection: " + req.params.collection + ".'}");
      }
      if (result) {
        res.send({
          "status": "successful"
        });
      }
      return db.close();
    });
  });
};

exports.save = function(req, res) {
  var id, idField;
  idField = req.params.idField;
  id = req.params.id;
  return connectDB(res, req, function(db) {
    var collection, query;
    query = {};
    query[idField] = id;
    query['deleted'] = false;
    collection = db.collection(req.params.collection);
    return collection.findOne(query, function(err, result) {
      if (err) {
        res.send('{"status": "Error Mongo connecting to Collection: #{req.params.collection}."}');
        return db.close();
      } else if (result) {
        req.body._id = result._id;
        return collection.save(req.body, {
          w: 1
        }, function(err, result) {
          if (err) {
            res.send('{status: "Error, Mongo save to Collection: #{req.params.collection} failed."}');
          } else {
            res.send('{"status": "saved"}');
          }
          return db.close();
        });
      } else {
        return db.close();
      }
    });
  });
};

exports["delete"] = function(req, res) {
  var id, idField;
  idField = req.params.idField;
  id = req.params.id;
  return connectDB(res, req, function(db) {
    var collection, query;
    query = {};
    query[idField] = id;
    collection = db.collection(req.params.collection);
    return collection.remove(query, {
      w: 1
    }, function(err, numberDeleted) {
      if (err) {
        return res.send('{"status": "delete failed"}');
      } else {
        return res.send('{"status": "deleted ' + numberDeleted + '"}');
      }
    });
  });
};

  return module.exports;
})({exports: $$___app_api_valetOpen}, $$___app_api_valetOpen);var $$___app_api = {};
$$___app_api = (function(module, exports) {
  var Authentication, ValetOpen, app, express;

express = require('express');

ValetOpen = $$___app_api_valetOpen;

Authentication = $$___app_api_authentication;

app = express();

app.use(express.bodyParser());

app.use(app.router);

app.configure("development", function() {
  app.use(express["static"](__dirname + "/public"));
  return app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});

app.configure("production", function() {
  app.use(express["static"](__dirname + "/public"));
  return app.use(express.errorHandler());
});

app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", 'Content-Type, X-Requested-With, Cache-Control, X-File-Name');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Cache-control', 'public');
  return next();
});

app.options("*", function(req, res, next) {
  return res.send(200);
});

app.get('/', function(req, res) {
  res.type('text/plain');
  return res.send('Valet Lifestyle API');
});

app.get('/v1/valet/group/:db/:collection/:idField/:id', ValetOpen.getGroup);

app.get('/v1/valet/:db/:collection/:idField/:id', ValetOpen.getItem);

app.post('/v1/valet/:db/:collection', ValetOpen.insert);

app.put('/v1/valet/:db/:collection/:idField/:id', ValetOpen.save);

app["delete"]('/v1/valet/:db/:collection/:idField/:id', ValetOpen["delete"]);

app.listen(8000);

console.log("express running at http://localhost:%d", 8000);

  return module.exports;
})({exports: $$___app_api}, $$___app_api);

//@ sourceMappingURL=api.js.map