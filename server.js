var http = require("http");
var fs = require("fs");
var url = require("url");
var qs = require("querystring");

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
				var file = get.file;
				var code = get.code;
				if(!fs.existsSync("files")) {
					fs.mkdirSync("files");
				}
				var any = false;
				var invalid = "\\/\"\'<>{}:%|?^+` \t";
				for(var i = 0; i < invalid.length; i++) {
					if(~code.indexOf(invalid.charAt(i))) {
						any = true;
						break;
					}
				}
				if(any) {
					res.end("3");
				}
				else if(file == "") {
					res.end("2");
				}
				else if(fs.existsSync("files/" + code)) {
					res.end("1");
				}
				else {
					fs.mkdirSync("files/" + code);
					fs.writeFile("files/" + code + "/" + file, data);
					res.end("0");
				}
			});
		}
		else {
			res.end("");
		}
	}
	else if(path == "exists") {
		res.end(fs.existsSync("files/" + get.code).toString());
	}
	else if(path.substring(0, 2) == "f/") {
		var code = path.substring(2);
		if(fs.existsSync("files/" + code)) {
			var files = fs.readdirSync("files/" + code);
			res.setHeader("Content-disposition", "attachment; filename=" + files[0]);
			res.end(fs.readFileSync("files/" + code + "/" + files[0]));
		}
		else {
			res.end("This file does not exist");
		}
	}
	else {
		res.end(fs.readFileSync("index.html"));
	}
}).listen(8080);