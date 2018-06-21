'use strict';
var path = require("path")

module.exports = {
    PATHS: {
        DIST: path.join(__dirname, "../dist"),
        LIB: path.join(__dirname, "../lib"),
        LIBG_LOB: ["./lib/**/*.js", "./lib/**/**/*.js"],
        SOURCE: "./src",
        SOURCE_GLOB: "./src/**/*.ts*",
        STYLES_GLOB: "./src/**/*.styl",
        STYLES_MAIN: ["./src/*/pp.program.styl"],
        SCRIPTS: "./.scripts",
        RELEASE: "./release",
        BUILD_GLOB: "./build/**/*",
        TEMPLATES: "./templates",
        TEMPLATES_TEMP: "./_templates",
        TEMPLATES_GLOB: "./templates/**/*",
        ROOT_TEMPLATE: path.join(__dirname, "../_templates/root"),
        ASSETS_TEMPLATE: path.join(__dirname, "../_templates/assets"),
        CONFIG_TEMPLATE: path.join(__dirname, "../_templates/config"),
    },
    VERSION_REPLACE_TOKEN: "{package-version}"
}
