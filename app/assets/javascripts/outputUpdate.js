outputUpdate = function(level) {
  $('#not-at-all').css("font-weight", "bold")
  $('#somewhat').css("font-weight", "normal")
  $('#core-belief').css("font-weight", "normal")

  if (level > 95) {
    $('#not-at-all').css("font-weight", "normal")
    $('#somewhat').css("font-weight", "normal")
    $('#core-belief').css("font-weight", "bold")
  } else if (level > 5) {
    $('#not-at-all').css("font-weight", "normal")
    $('#somewhat').css("font-weight", "bold")
    $('#core-belief').css("font-weight", "normal")
  };
  // document.querySelector('#level').value = phrase;
}
