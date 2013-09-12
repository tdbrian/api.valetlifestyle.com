
# Valet Lifestyle API (Main Dameon)
# 
# @author     Thomas Brian  <tdbrian@gmail.com>
# @created    Sept 12, 2013
# 

# REQUIRES
# ////////////////////////////////////////////////////////////////////////////////////////
#//# sourceMappingURL= app.js.map
#require('source-map-support').install()
express = require 'express'
ValetOpen = require './api/valetOpen'
Authentication = require './api/authentication'

# CONFIGURE
# ////////////////////////////////////////////////////////////////////////////////////////

app = express()

app.use(express.bodyParser())
app.use app.router

app.configure "development", ->
  app.use express.static(__dirname + "/public")
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  ),

app.configure "production", ->
  app.use express.static(__dirname + "/public")
  app.use express.errorHandler()

# Additional Cross Domain Header Info
# CORS Support in my Node.js web app written with Express
# http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
app.all '/*', (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", 'Content-Type, X-Requested-With, Cache-Control, X-File-Name')
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
    res.header('Cache-control', 'public')
    next()

# handle OPTIONS requests from the browser
app.options "*", (req,res,next) ->
  res.send(200)

# ROUTES
# ////////////////////////////////////////////////////////////////////////////////////////

# Home
app.get '/', (req, res) ->
  res.type 'text/plain' 
  res.send 'Valet Lifestyle API'

# Valet Mongo
app.get '/v1/valet/group/:db/:collection/:idField/:id', ValetOpen.getGroup
app.get '/v1/valet/:db/:collection/:idField/:id', ValetOpen.getItem
app.post '/v1/valet/:db/:collection', ValetOpen.insert
app.put '/v1/valet/:db/:collection/:idField/:id', ValetOpen.save
app.delete '/v1/valet/:db/:collection/:idField/:id', ValetOpen.delete

# LISTEN ON PORT 8855
# ////////////////////////////////////////////////////////////////////////////////////////

app.listen 8855
console.log "express running at http://localhost:%d", 8855

