var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var fileSchema = new Schema({

});

var File = mongoose.model('File', fileSchema);
return File;
