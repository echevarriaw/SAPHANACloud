const express = require('express');
const app = express();

app.get('/', function (req, res) {
	res.type('text/html').status(200).send('<html><head></head><body></body></html>');
});

const port = process.env.PORT || 3000;
app.listen(port, function () {
	console.info('Listening on port: ' + port);
});
