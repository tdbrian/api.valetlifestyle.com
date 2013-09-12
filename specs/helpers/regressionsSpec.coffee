
Regressions = require "../../app/helpers/regressionsNew"
HttpMocks = require('node-mocks-http')
Portal = require('../../app/models/Portal')

# jasmine.getEnv().defaultTimeoutInterval = 500

# it "should respond with hello world", (done) ->
#   request "http://localhost:3000/hello", (error, response, body) ->
#     done()

Portal.Portal.find {pid: "17"}, (err, _portal) ->

	req = HttpMocks.createRequest
		method: "GET"
		url: "/v1"
		params:
		  portal: _portal
		  pointName: "TotalCampusPowerConsumption"
		  benchmarkType: "predictive"

	res = HttpMocks.createResponse()

	Regressions.getRegressionData req, res
	# data = JSON.parse(response._getData())

