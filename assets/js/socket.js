import {Socket} from "phoenix"
export default socket
// TODO remove react
// import React from 'react';
// import ReactDOM from 'react-dom';

let socket = new Socket("/socket", {params: {token: window.userToken}})
let subtopic = $('h2#forum-name').data('forum-id');
let chan = socket.channel("forum:" + subtopic, {});
let new_message_box = $("#new-message-content")[0];
let current_user_id = $("#username").data("user-id")

socket.connect()

function channel_init() {

  if($('body').data('page') == "StyleView/show" ||
  	  $('body').data('page') == "BreweryView/show") {

		let submitButtonObject = $("a#submit-button");
		let submitButton = submitButtonObject[0];

		if(new_message_box) {
			new_message_box.value = "";
		}

		chan.join()
		  .receive("ok", resp => { console.log('Joined channel ' + subtopic + ' successfully', resp) })
		  .receive("error", resp => { console.log('Unable to join', resp) })

		// receive from channel
		chan.on("create", got_create);
		chan.on("update", got_update);
		chan.on("delete", got_delete);

		// event listeners
		if(submitButton) {
			submitButton.addEventListener("click", new_message(submitButtonObject));
		}
		add_event_listeners(0);
	}
}

$(channel_init);

function add_event_listeners(id) {
	let messages = id ? $("#message-" + id) : $("[id^=message-]");

	for (let i = 0; i < messages.length; i++) {
		let message_id = messages[i].id.substring(8);
		let edit_button = $("#edit-" + message_id);
		let delete_button = $("#delete-" + message_id);

		if(edit_button.length == 1) {
			edit_button[0].addEventListener("click", edit_message(message_id));
			delete_button[0].addEventListener("click", delete_message(message_id));
		}
	}
}

// NEW
function new_message(button) {
	return function() {
		content = new_message_box.value;

		if(content && content.length) {
			chan.push("create",
								{content: content,
		     				 forum_id: subtopic.toString(),
		     				 user_id: current_user_id});
			$('#message_content').val('');
			new_message_box.value = "";
		}
	}
}

// CREATE
function got_create(msg) {
	if(msg.forum_id == subtopic) {
		let buttons = "";
		
		if(msg.user_id == current_user_id) {
			buttons =
			'<td class="pl-0"> \
		  	<a href="#a" class="edit-button" id="edit-' + msg.id + '">Edit</a> \
		  </td> \
		  <td class="pl-0"> \
		  	<a href="#a" class="delete-button" id="delete-' + msg.id + '">Delete</a> \
		  </td>';
		}

	 	let message_row =
			'<tr class="message-row" id="message-' + msg.id + '"> \
			  <td id="author-' + msg.id + '"><strong>' + msg.username + ' </strong></td> \
			  <td id="content-td-' + msg.id + '"> \
			    <div id="content-' + msg.id + '">' + msg.content + '</div> \
			    <div id="timestamp-' + msg.id + '" class="timestamp mt-3">' + msg.timestamp + '</div> \
			  </td>' +
	  			buttons +
	  	'</tr>';

		$('tbody#messages-table-body').prepend(message_row);
		add_event_listeners(msg.id);
	}
}

// EDIT
function edit_message(id) {
	return function() {
		let content_td = $("#content-td-" + id)
		let content = $("#content-" + id);
		let edit_button = $("#edit-" + id);

		if(edit_button.text() === "Edit") {
			let input = '<div><input type="text" id="content-' + id + '" value="' + content.text() + '"></div>'
			content.remove()
			content_td.prepend(input);
			edit_button.text('Update');
		}
		else {
			let content_text = content[0].value
			edit_button.text('Edit');
			chan.push("update", {id: id,
			                     content: content_text,
			                     forum_id: subtopic});
			content_td.children()[0].remove();
			content_td.prepend('<div id="content-' + id + '">' + content_text + '</div>');
		}
	};
}

// UPDATE
function got_update(msg) {
	if(msg.forum_id == subtopic) {
		$("#content-" + msg.id)[0].firstChild.data = msg.content;
	}
}

// DELETE
function delete_message(id) {
	return function() {
		if(confirm('Are you sure?')) {
			chan.push("delete", {id: id, forum_id: subtopic});
		}
	};
}

function got_delete(msg) {
	$('#message-' + msg.id).remove();
}
