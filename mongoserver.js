var express = require("express");
var mongoose = require("mongoose");
var fs = require("fs");

var AWS = require("aws-sdk");
AWS.config.loadFromPath("./aws-config.json");
var AWSBucket = new AWS.S3({
    params: {
        Bucket: "files.unofile.net"
    }
});
var s3stream = require("s3-upload-stream")(AWSBucket);

mongoose.connect('mongodb://localhost:27017/testing');
var File = require("./models/File.js");

var app = express();
app.listen(80);

app.use(function(req, res, next) {
    var path = req.path.substring(1);
    if (~["js/jquery-2.1.3.min.js", "css/bootstrap.min.css", "css/index.css"].indexOf(path)) {
        res.end(fs.readFileSync(path));
    } else if (~["", "/index.html", "/"].indexOf(path)) {
        res.end(fs.readFileSync("index.html"));
    } else {
        next();
    }
});

app.post("/upload", function(req, res) {

    var fileId = "";
    var file = req.query.file;
    var code = req.query.code;
    var isForever = true;
    if (req.query.forever == "false") {
        isForever = false;
    }
    var any = false;
    var invalid = "\\/\"\'<>{}:%|?^+` \t";
    for (var i = 0; i < invalid.length; i++) {
        if (~code.indexOf(invalid.charAt(i))) {
            any = true;
            break;
        }
    }
    if (any) {
        res.end("3");
    }
    if (file == "") {
        res.end("2");
    }
    File.count({
        code: code
    }, function(err, count) {
        if (count > 0) {
            res.end("1");
        } else {
            File.create({
                name: file,
                code: code,
                isForever: isForever
            }, function(err, fileInfo) {
                if (err) {
                    res.end("4");
                } else {
                    var upload = s3stream.upload({
                        Bucket: "files.unofile.net",
                        Key: fileInfo._id + "",
                        ACL: "public-read",
                        ContentType: "binary/octet-stream"
                    });
                    upload.on('part', function(details) {
                        console.log(details);
                    });
                    upload.on('error', function(error) {
                        console.log(error);
                    });
                    upload.on('uploaded', function(details) {
                        console.log(details);
                    });
                    req.pipe(upload);
                }
            });
        }
    });



});
