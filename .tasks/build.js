'use strict';
var gulp = require("gulp"),
    configuration = require('./@configuration.js');

gulp.task("copyPnpTemplates", () => {
    return gulp.src(configuration.PATHS.TEMPLATES_GLOB)
        .pipe(gulp.dest(configuration.PATHS.TEMPLATES_TEMP));
});