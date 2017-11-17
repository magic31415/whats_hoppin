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
$(function () {
	var max = 0;
	for (var i = 0 ; i < $(".card").length; i++) {
		var thisHeight = $(".card").eq(i).height();
		if(thisHeight >= max){
			max = currentHeight;
		}
  }
  $(".card").height(max);
});