
HttpMocks = require('node-mocks-http')
Predictive = require("../../app/api/predictive")

# jasmine.getEnv().defaultTimeoutInterval = 500

# it "should respond with hello world", (done) ->
#   request "http://localhost:3000/hello", (error, response, body) ->
#     done()

req = HttpMocks.createRequest
	method: "GET"
	url: "/v1/generateMeter/30/:pointname/:bid/:startDate/:endDate/:hbp/:cbp"
	params:
	  pid: "30"

res = HttpMocks.createResponse()

Predictive.generateMeter req, res
# data = JSON.parse(response._getData())