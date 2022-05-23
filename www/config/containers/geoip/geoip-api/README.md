# GeoIP API

This is a simple node server with the sole purpose of returning a JSON blob describing the geographic information of an IP. 

## Getting Started

To install, simply run:

    npm install 

Update the MaxMind GEO IP DB:

    cd node_modules/geoip-lite/ && npm run-script updatedb

To start the server, run:

    Run `node server.js`
    
Note, you can export the environment variable `PORT` to change the listening port of the server. The default port is `8000`. To enable debugging, export `DEBUG` to some value greater than 0. 


## Query the API

You can query the API passing an IP:

    curl http://localhost:8000/locate?ip=172.56.38.211

Or you can rely on the public IP being determined by server:

    curl http://localhost:8000/locate

## Response format

A successful response will look like this:

    {
      range: [ 2889360896, 2889361329 ],
      country: "US",
      region: "CA",
      city: "Oakland",
      ll: [ 37.8044, -122.2708 ],
      metro: 807,
      ip: "172.56.38.211",
      error: false
    }

An unsuccessful response will look something more like this:

    {
      ip: "172.56.38.211",
      error: "Something went wrong"
    }


## Other info

Checkout the Dockerfile for how to build a container from this package.

