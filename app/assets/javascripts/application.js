// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require d3
//= require jquery
//= require jquery-ui/tooltip
//= require jquery_ujs
//= require underscore
//= require bootstrap-sprockets
//= require jsapi
//= require chartkick
//= require_tree .



// we turned of the requiring tree for some reason it works.

function bindRefreshButton() {
	$('#refresh_this').click(function(e) {
		e.preventDefault();
		if (this.classList[0] == 'skip') {
			beliefId = $('#belief_id').val();
			$.ajax({
				type: "POST",
			  url: "/users/skip",
			  data: {id: beliefId}
			});
		} else if (this.classList[0] == 'skip-other') {
			beliefId = "other";
			$.ajax({
				type: "POST",
			  url: "/users/skip",
			  data: {id: beliefId}
			});
		}
    $('.refresh').load('/users/refresh_question');
  });
}

function bindSubmitButton() {
	$('.slider-submit').click(function(e) {
		e.preventDefault();
		conviction = $('#conviction').val();
		beliefId = $('#belief_id').val();

		$.ajax({
			type: "POST",
		  url: "/user_beliefs",
		  data: {belief: beliefId,
		  			 conviction: conviction}
		})
			.done(function() {
				if (parseInt(conviction) > 5) {
					window.location.href = "/users";
				}
			});

		if (parseInt(conviction) <= 5) {
	    $('.refresh').load('/users/refresh_question');
	    $('#refresh-'+beliefId).empty();
		}
	});
}

$(document).ready(function(){

	// $(".tooltip").tooltip();
	$("a[rel=tooltip]").tooltip();

	$('#core-belief').click(function(e) {
		e.preventDefault();
		outputUpdate(100);
		$('#conviction').val(100);
	});

	$('#somewhat').click(function(e) {
		e.preventDefault();
		outputUpdate(50);
		$('#conviction').val(50);
	});

	$('#not-at-all').click(function(e) {
		e.preventDefault();
		outputUpdate(0);
		$('#conviction').val(0);
	});

  $('.subscribe').click(function(e) {
    e.preventDefault();
    $('.table-slider').empty();

    $('#refresh-'+this.classList[1]).load('/users/refresh_question?sliderOnly=true&id=' + this.classList[1]);
  });

  $('.reply').click(function(e) {
  	e.preventDefault();
    $('.reply-form').hide();
  	$('#reply-form-'+this.classList[1]).show().load('/comments/form?comment_id=' + this.classList[1]);
  })

});


