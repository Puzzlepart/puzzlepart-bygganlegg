'use strict';
var gulp = require("gulp"),
    path = require("path"),
    pluginError = require('plugin-error'),
    powershell = require("./utils/powershell.js"),
    configuration = require('./@configuration.js');

gulp.task("packagePnpTemplates", (done) => {
    powershell.execute("Generate-PnP-Files.ps1", "", done);
});