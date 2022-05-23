var express = require('express');
var geoip = require('geoip-lite');

var port = process.env.PORT || 8000
var debug = process.env.DEBUG || 0;
var app = express();

// Enable serving of static assets in public
app.use(express.static('public'));

// Enable CORS
app.all('*', function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'X-Requested-With');
  res.header('Content-Type', 'application/json');
  next();
 });
 
app.get('/locate', function(req, res) {
  // Getting the ip of the client from the query parameter, request headers or remoteAddress
  var ip = req.query.ip,
      xForwardedFor = (req.headers['x-forwarded-for'] || '').split(/,/)[0],
      remoteAddress = req.connection.remoteAddress,
      geo,
      response;

  ip = ip || xForwardedFor || remoteAddress;

  geo = geoip.lookup(ip);
  if(geo === undefined || geo === null) {
    geo = {};
    geo.ip = ip;
    geo.error = 'undefined';
  } else {
    geo.ip = ip;
    geo.error = false;
  }
  response = JSON.stringify(geo);
  /*
  { ip: 1.2.3.4,
    range: [ 3479299040, 3479299071 ],
    country: 'US',
    region: 'CA',
    city: 'San Francisco',
    ll: [37.7484, -122.4156] }
    */  
  if(debug > 0) {
    console.log('reply', response);
  }
  res.end(response);
});

var server = app.listen(port, function() {
  console.log('GeoIP API: Web service listening on port ' + server.address().port);
});



