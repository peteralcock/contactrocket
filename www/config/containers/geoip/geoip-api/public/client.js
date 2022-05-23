/*jslint indent: 2 */
/*jslint nomen: true */
/*jslint white: true */
/*jslint plusplus: true */
/*global document, window, location, alert, console, require, XMLHttpRequest, JSON */

var GeoIP;

(function() {
  "use strict";

  GeoIP = (function() {
    function GeoIP() { return this; }

    GeoIP.init = function() {
      return this;
    };

    GeoIP.location = false;

    GeoIP.endpoint = '/locate';
 
    GeoIP.locate = function(successCallback, errorCallback, ip) {
      var xhr = new XMLHttpRequest(),
          url = GeoIP.endpoint,
          json;

      if(ip !== undefined) {
        url += "?ip="+ip;
      }
      xhr.open("GET", url, true);
      xhr.timeout = 10000;
      xhr.onload = function (e) {
        if (xhr.readyState === 4) {
          json = JSON.parse(xhr.responseText);
          if(json.error) {
            if(errorCallback) {
              errorCallback(json.ip, json.error);
            }
           } else {
            if(successCallback) {
              GeoIP.location = json;
              successCallback(json.ip, json, location);
            }
          }
        } else {
          //console.error(xhr.statusText);
          errorCallback(ip, xhr.statusText);
        }
      };

      xhr.ontimeout = function (e) { 
        if(errorCallback) {
          errorCallback(ip, e);
        }
      };
   
      xhr.send();
    };
    return GeoIP;

  }(this));

  GeoIP.init();

}(this));
