var express = require("express");
var mongoose = require("mongoose");
var fs = require("fs");

var app = express();
app.listen(80);

app.use(function(req, res, next){
  var path = req.path.substring(1);
  if(~["js/jquery-2.1.3.min.js", "css/bootstrap.min.css", "css/index.css"].indexOf(path)) {
		res.end(fs.readFileSync(path));
	}
  else if (~["", "/index.html", "/"].indexOf(path)){
    res.end(fs.readFileSync("index.html"));
  }
  else {
    next();
  }
});
