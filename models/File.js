var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var fileSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    code: {
        type: String,
        required: true,
        unique: true
    },
    isForever: {
        type: Boolean,
        required: true
    },
});

var File = mongoose.model('File', fileSchema);
module.exports = File;
