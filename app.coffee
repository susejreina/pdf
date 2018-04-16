express = require 'express'
fs = require 'fs'
pdf = require './pdf'
openssl = require './openssl'

app = express();

app.get '/pdf', pdf.createPDF
app.get '/open', openssl.ejecutarOpen

app.get '/', (req, res) ->
	res.send "Hello World"

app.listen 3000, () ->
	console.log 'Example app listening on port 3000!'

