'use strict';
var gulp = require("gulp"),
    clean = require('gulp-clean'),
    configuration = require('./@configuration.js');

gulp.task("clean", done => {
    return gulp.src([configuration.PATHS.LIB], { read: false })
        .pipe(clean());
});