outputUpdate = function(level) {
  $('#1').css("font-weight", "bold")
  $('#2').css("font-weight", "normal")
  $('#2').css("font-weight", "normal")

  if (level > 95) {
    $('#1').css("font-weight", "normal")
    $('#2').css("font-weight", "normal")
    $('#3').css("font-weight", "bold")
  } else if (level > 5) {
    $('#1').css("font-weight", "normal")
    $('#2').css("font-weight", "bold")
    $('#3').css("font-weight", "normal")
  };
  // document.querySelector('#level').value = phrase;
}
