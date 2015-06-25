var http = require("http");
var fs = require("fs");
var url = require("url");
var qs = require("querystring");
var sqlite = require("sqlite3");
var db = new sqlite.Database("data.db");

http.createServer(function(req, res) {
	var path = url.parse(req.url).pathname.substring(1);
	var get = qs.parse(url.parse(req.url).query);
	if(~["js/jquery-2.1.3.min.js", "css/bootstrap.min.css", "css/index.css"].indexOf(path)) {
		res.end(fs.readFileSync(path));
		return;
	}
	else if(path == "upload") {
		if(req.method == "POST") {
			var data = new Buffer(0);
			req.on("data", function(chunk) {
				data = Buffer.concat([data, chunk]);
			});
			req.on("end", function() {
				var file = unescape(get.file);
				var code = unescape(get.code);
				db.serialize(function() {
					db.run("CREATE TABLE IF NOT EXISTS Files (code TEXT, fileName TEXT, fileData BLOB)");
 					db.all("SELECT code FROM Files WHERE code = '" + code + "'", function(err, result) {
 						console.log(result);
 						var any = false;
						var invalid = "\\/\"\'<>{}:%|?^+` \t";
						for(var i = 0; i < invalid.length; i++) {
							if(~code.indexOf(invalid.charAt(i))) {
								any = true;
								break;
							}
						}
						if(any){
 							res.end("3");
 						}
 						else if(file == ""){
 							res.end("2");
 						}
 						else if(result.length > 0) {
							res.end("1");
							console.log(typeof(result))
						}
						else {
 							var sql = db.prepare("INSERT INTO Files VALUES ('"+ [code, file].join("','")+ "', ?)");
 							sql.run(data);
 							sql.finalize();
 							res.end("0");
						}
 					});
				});
			});
		}
		else {
			res.end("");
		}
	}
	else if(path == "exists") {
		db.run("CREATE TABLE IF NOT EXISTS Files (code TEXT, fileName TEXT, fileData BLOB)");
		db.all("SELECT * FROM Files WHERE code = '" + unescape(get.code) + "'", function(err, result) {
			res.end((result.length > 0).toString());
		});
	}
	else if(path.substring(0, 2) == "f/") {
		var code = unescape(path.substring(2));
		db.serialize(function() {
			db.run("CREATE TABLE IF NOT EXISTS Files (code TEXT, fileName TEXT, fileData BLOB)");
			db.all("SELECT * FROM Files WHERE code = '" + code + "'", function(err, result) {
				if (typeof(result) != "undefined"&&result.length == 1){
					res.setHeader("Content-disposition", "attachment; filename=" + result[0].fileName);
					res.end(result[0].fileData);
				}
				else {
					res.end("This file does not exist");				
				}
			});
		});
	}
	else if(path == "ping") {
		res.end("pong");
	}
	else {
		res.end(fs.readFileSync("index.html"));
	}
}).listen(80);