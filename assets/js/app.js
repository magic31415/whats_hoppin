// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// import "phoenix_html"
import socket from "./socket";

"use strict";

// let handlebars = require("handlebars");

// on page load, figure out the height of the largest card, and make all cards that same height
// also, activate the popover windows
$(function () {

	// activate all hover-over popover windows
	$('[data-toggle="hover"]').popover();

	let max = 0;
	for (let i = 0 ; i < $(".card").length; i++) {
		let thisHeight = $(".card").eq(i).height();
		max = (thisHeight >= max) ? thisHeight : max;
  }

  // set all cards to the same height
	$(".card").height(max);
});

// front-end form validation
let username_field = $("input#user_username")[0];
let email_field = $("input#user_email")[0];
let password_field = $("input#user_password")[0];
let confirmation_field = $("input#user_password_confirmation")[0];

$(document).ready(function() {
	if ($('body').data('page') == "UserView/new"
	 || $('body').data('page') == "UserView/edit") {

		username_field.addEventListener("blur", username_validation);
	  email_field.addEventListener("blur", email_validation);
	  password_field.addEventListener("blur", password_validation);
	  confirmation_field.addEventListener("blur", confirmation_validation);
	}
});

function username_validation() {
	let username = username_field.value;
	let error_span = $("#username-front-validation");

	if (username.length == 0) {
		error_span.text("Can't be blank");
	}
	else if (username.length > 20) {
		error_span.text("Can't contain more than 20 characters");
	}
	else {
		error_span.text("");
	}
	// TODO already in use
}

function email_validation() {
	let email = email_field.value;
	let regex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
	let error_span = $("#email-front-validation");

	if (email.length == 0) {
		error_span.text("Can't be blank");
	}
	else if(email.length > 100) {
		error_span.text("Can't contain more than 100 characters");
	}
	else if(!email.match(regex)) {
		error_span.text("Invalid email address");
	}
	else {
		error_span.text("");
	}
	// TODO already in use
}

function password_validation() {
	let password = password_field.value;
	let error_span = $("#password-front-validation");

	if (password.length == 0) {
		error_span.text("Can't be blank");
	}
	else if(password.length < 8) {
		error_span.text("Must be at least 8 characters long");
	}
	else {
		error_span.text("");
	}
}

function confirmation_validation() {
	let password = password_field.value;
	let confirmation = confirmation_field.value;
	let error_span = $("#confirmation-front-validation");

	if(password != confirmation) {
		error_span.text("Password and password confirmation don't match")
	}
	else {
		error_span.text("");
	}
}








