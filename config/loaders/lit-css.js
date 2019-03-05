var loaderUtils = require("loader-utils");

module.exports = function () {};

module.exports.pitch = function(request) {
  if (this.cacheable) this.cacheable();
  return [
    "",
    "var content = require(" + loaderUtils.stringifyRequest(this, "!!" + request) + ");",
    "",
    "import { css, unsafeCSS } from 'lit-element';",
    "",
    "export default unsafeCSS(content);",
  ].join("\n");
};