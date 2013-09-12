
# Valet Lifestyle 
# 
# @author     Thomas Brian  <tdbrian@gmail.com>
# @created    Sept 12, 2013
# 

# Requires
# ////////////////////////////////////////////////////////////////////////////////////////
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

# Gets an array of items from the collection
exports.getGroup = (req, res) ->
    
    idField = req.params.idField
    id = req.params.id
    
    connectDB res, req, (db) ->

        query = {}
        query[idField] = id
        query['deleted'] = false

        collection = db.collection req.params.collection
        collection.find(query).toArray (err, results) ->
            
            if err
                res.send '{status: "Error Mongo connecting to Collection: #{req.params.collection}."}'

            if results
                res.send results

            db.close()

# Gets single item form collection
exports.getItem = (req, res) ->

    idField = req.params.idField
    id = req.params.id

    connectDB res, req, (db) ->

        query = {}
        query[idField] = id
        query['deleted'] = false

        collection = db.collection req.params.collection
        collection.findOne query, (err, results) ->
            
            if err
                res.send '{status: "Error Mongo connecting to Collection: #{req.params.collection}."}'

            if results

                res.send results

            db.close()

# Inserts item to collection
exports.insert = (req, res) ->

    connectDB res, req, (db) ->

        collection = db.collection req.params.collection
        collection.save req.body, {w: 1}, (err, result) ->
            if err
                res.send "{status: 'Error Mongo connecting to Collection: #{req.params.collection}.'}"

            if result
                res.send {"status": "successful"}

            db.close()

# Saves item to collection
exports.save = (req, res) ->

    idField = req.params.idField
    id = req.params.id

    connectDB res, req, (db) ->

        query = {}
        query[idField] = id
        query['deleted'] = false

        collection = db.collection req.params.collection
        collection.findOne query, (err, result) ->

            if err
                res.send '{"status": "Error Mongo connecting to Collection: #{req.params.collection}."}'
                db.close()

            else if result
                
                req.body._id = result._id
                collection.save req.body, {w: 1}, (err, result) ->

                    if err
                        res.send '{status: "Error, Mongo save to Collection: #{req.params.collection} failed."}'
                    else
                        res.send '{"status": "saved"}'

                    db.close()
            else
                db.close()

# Deletes item from collection
exports.delete = (req, res) ->
    
    idField = req.params.idField
    id = req.params.id
    
    connectDB res, req, (db) ->    
        query = {}
        query[idField] = id

        collection = db.collection req.params.collection
        collection.remove query, {w:1}, (err, numberDeleted) ->

            if err
                res.send '{"status": "delete failed"}'
            else
                res.send '{"status": "deleted ' + numberDeleted + '"}'
