import {Socket} from "phoenix"
export default socket
// TODO remove react
// import React from 'react';
// import ReactDOM from 'react-dom';

let socket = new Socket("/socket", {params: {token: window.userToken}})
let subtopic = $('h2#forum-name').data('forum-id');
let chan = socket.channel("forum:" + subtopic, {});
let new_message_box = $("#new-message-content")[0];

socket.connect()

function channel_init() {
	if ($('div#is-forum').data('is-forum') == true) {

		let submitButtonObject = $("a#submit-button");
		let submitButton = submitButtonObject[0];
		new_message_box.value = "";

		chan.join()
		  .receive("ok", resp => { console.log('Joined channel ' + subtopic + ' successfully', resp) })
		  .receive("error", resp => { console.log('Unable to join', resp) })

		// receive from channel
		chan.on("create", got_create);
		chan.on("update", got_update);
		chan.on("delete", got_delete);

		// event listeners
		submitButton.addEventListener("click", new_message(submitButtonObject));
		add_event_listeners(0);
	}
}

$(channel_init);

// TODO simplify
function add_event_listeners(id) {
	let messages = id ? $("#message-" + id) : $("[id^=message-]");
	let edit_buttons = Array.from(messages.find("a.edit-button"));
	let delete_buttons = Array.from(messages.find("a.delete-button"));

	for (let i = 0; i < messages.length; i++) {
		let message_id = messages[i].id.substring(8);
		edit_buttons[i].addEventListener("click", edit_message(message_id));
		delete_buttons[i].addEventListener("click", delete_message(message_id));
	}
}

// NEW
function new_message(button) {
	return function() {
		content = new_message_box.value;
		if(content && content.length) {
			chan.push("create",
								{content: content,
		     				 forum_id: subtopic.toString()});
			$('#message_content').val('');
			new_message_box.value = "";
		}
	}
}

// CREATE
function got_create(msg) {
	if(msg.forum_id == subtopic) {
	 	let message_row =
			'<tr id="message-' + msg.id + '"> \
	  		<td id="content-' + msg.id + '">' + msg.content + '</td> \
	  		<td class="text-right"> \
	  			<span><a href="#a" \
	  							 class="btn btn-outline-warning btn-xs edit-button" \
	  							 id="edit-' + msg.id + '">Edit</a></span> \
	  			<span><a href="#a" \
	  							 class="btn btn-danger btn-xs delete-button" \
	  							 id="delete-' + msg.id + '">Delete</a></span> \
	  		</td> \
	  	</tr>';

		$('tbody#messages-table-body').prepend(message_row);
		add_event_listeners(msg.id);
	}
}

// EDIT
function edit_message(id) {
	return function() {
		let message = $("#message-" + id);
		let content = $("#content-" + id);
		let edit_button = $("#edit-" + id);

		if(edit_button.text() === "Edit") {
			let input = '<td> \
										<input type="text" id="content-' + id + '" value="' + content.text() + '"> \
									</td>'
			content.remove();
			message.prepend(input);
			edit_button.text('Update');
		}
		else {
			let content_text = content[0].value
			edit_button.text('Edit');
			chan.push("update", {id: id,
			                     content: content_text,
			                     forum_id: subtopic});
			content.parent().remove();
			message.prepend('<td id="content-' + id + '">' + content_text + '</td>');
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
