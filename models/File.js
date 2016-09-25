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
    },
    isForever: {
        type: Boolean,
        required: true
    },
    downloadable: {
        type: Boolean,
        required: true
    },
    uploading: {
        type: Boolean,
        required: true
    }
});

var File = mongoose.model('File', fileSchema);
module.exports = File;
