var express = require("express");
var mongoose = require("mongoose");
var fs = require("fs");
var multer = require("multer");

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

app.get("/exists", function(req, res){
    var code = req.query.code;
    File.count({
        code: code,
        $or: [
            {uploading: true},
            {downloadable: true}
        ]
    }, function(err, count){
        res.end((count > 0).toString());
    });
});

app.get("/f/:code", function(req, res){
    File.findOne({
        code: req.params.code,
        downloadable: true
    }, function(err, file){
        if (!file){
            res.end("This file does not exist");
        }
        else {
            var url = AWSBucket.getSignedUrl("getObject", {
                Key: file._id+"",
                Expires: 60
            });
            if (file.isForever){
                res.redirect(url);
            }
            else {
                File.update({
                    _id: file._id
                },{$set : {
                    downloadable: false
                }}, function(err){
                    res.redirect(url);
                });
                // AWSBucket.deleteObject({
                //     Key: file._id+""
                // }, function(err){
                //     File.remove({
                //         code: req.params.code
                //     });
                // });
            }
        }
    });
});

app.post("/upload", function(req, res) { //50mb
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
        code: code,
        $or: [
            {uploading: true},
            {downloadable: true}
        ]
    }, function(err, count) {
        if (count > 0) {
            res.end("1");
        } else {
            console.log(count)
            File.create({
                name: file,
                code: code,
                isForever: isForever,
                downloadable: false,
                uploading: true
            }, function(err, fileInfo) {
                if (err) {
                    res.end("4");
                } else {
                    var upload = s3stream.upload({
                        Bucket: "files.unofile.net",
                        Key: fileInfo._id + "",
                        ACL: "public-read",
                        ContentType: "binary/octet-stream",
                        ContentDisposition: "attachment; filename="+fileInfo.name
                    });
                    upload.on('part', function(details) {//May use later for progress
                        //console.log(details)
                    });
                    upload.on('error', function(error) {
                        res.end("4");
                    });
                    //A cancelled upload may keep uploading:true forever
                    upload.on('uploaded', function(details) {
                        File.update({
                            _id: fileInfo._id
                        },{$set : {
                            downloadable: true,
                            uploading: false
                        }}, function(err){
                            res.end("0");
                        });
                    });
                    req.pipe(upload);
                }
            });
        }
    });
});
