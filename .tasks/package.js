'use strict';
var gulp = require("gulp"),
    powershell = require("./utils/powershell.js");

gulp.task("packagePnpTemplates", (done) => {
    powershell.execute("Generate-PnP-Files.ps1", "", done);
});