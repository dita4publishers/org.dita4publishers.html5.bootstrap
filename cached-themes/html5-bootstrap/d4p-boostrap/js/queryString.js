function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(document.referrer);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
