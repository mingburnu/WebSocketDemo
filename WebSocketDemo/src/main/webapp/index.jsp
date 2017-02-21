<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WebSocket ChatRoom</title>
<link href="./resource/css/bootstrap.css" rel="stylesheet">
<link href="./resource/css/bootstrap-responsive.css" rel="stylesheet">

<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src="./resource/js/html5shiv.js"></script>
    <![endif]-->

<!-- Fav and touch icons -->
<link rel="apple-touch-icon-precomposed" sizes="144x144"
	href="./resource/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114"
	href="./resource/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72"
	href="./resource/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed"
	href="./resource/ico/apple-touch-icon-57-precomposed.png">
<link rel="shortcut icon" href="./resource/ico/favicon.png">
<script src="resource/js/jquery-1.10.2.min.js"></script>
<script>
	var wsocket;
	var serviceLocation = "ws://127.0.0.1:<%=request.getLocalPort() + request.getContextPath()%>/chat/";
	var $nickName;
	var $message;
	var $chatWindow;
	var room = '';

	function onMessageReceived(evt) {
		//var msg = eval('(' + evt.data + ')');
		var msg = JSON.parse(evt.data); // native API
		var $messageLine = $('<tr><td class="received">' + msg.received
				+ '</td><td class="user label label-info">' + msg.sender
				+ '</td><td class="message badge">' + msg.message
				+ '</td></tr>');
		$chatWindow.append($messageLine);
	}
	function sendMessage() {
		var msg = '{"message":"' + $message.val() + '", "sender":"'
				+ $nickName.val() + '", "received":""}';
		wsocket.send(msg);
		$message.val('').focus();
	}

	function connectToChatserver() {
		room = $('#chatroom option:selected').val();
		wsocket = new WebSocket(serviceLocation + room);
		wsocket.onmessage = onMessageReceived;
	}

	function leaveRoom() {
		wsocket.close();
		$chatWindow.empty();
		$('.chat-wrapper').hide();
		$('.chat-signin').show();
		$nickName.focus();
	}

	$(document).ready(
			function() {
				$nickName = $('#nickname');
				$message = $('#message');
				$chatWindow = $('#response');
				$('.chat-wrapper').hide();
				$nickName.focus();

				$('#enterRoom').click(
						function(evt) {
							evt.preventDefault();
							connectToChatserver();
							$('.chat-wrapper h2').text(
									'Chat # ' + $nickName.val() + "@" + room);
							$('.chat-signin').hide();
							$('.chat-wrapper').show();
							$message.focus();
						});
				$('#do-chat').submit(function(evt) {
					evt.preventDefault();
					sendMessage()
				});

				$('#leave-room').click(function() {
					leaveRoom();
				});
			});
</script>
<style type="text/css">
body {
	padding-top: 40px;
	padding-bottom: 40px;
	background-color: #f5f5f5;
}

.form-signin {
	max-width: 300px;
	padding: 19px 29px 29px;
	margin: 0 auto 20px;
	background-color: #fff;
	border: 1px solid #e5e5e5;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
	box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
}

.form-signin .form-signin-heading,.form-signin .checkbox {
	margin-bottom: 10px;
}

.form-signin input[type="text"],.form-signin input[type="password"] {
	font-size: 16px;
	height: auto;
	margin-bottom: 15px;
	padding: 7px 9px;
}

#chatroom {
	font-size: 16px;
	height: 40px;
	line-height: 40px;
	width: 300px;
}

.received {
	width: 160px;
	font-size: 10px;
}
</style>
</head>
<body>

	<div class="container chat-signin">
		<form class="form-signin">
			<h2 class="form-signin-heading">Chat sign in</h2>
			<label for="nickname">Nickname</label> <input type="text"
				class="input-block-level" placeholder="Nickname" id="nickname">
			<div class="btn-group">
				<label for="chatroom">Chatroom</label> <select size="1"
					id="chatroom">
					<option>arduino</option>
					<option>java</option>
					<option>groovy</option>
					<option>scala</option>
				</select>
			</div>
			<button class="btn btn-large btn-primary" type="submit"
				id="enterRoom">Sign in</button>
		</form>
	</div>
	<!-- /container -->

	<div class="container chat-wrapper">
		<form id="do-chat">
			<h2 class="alert alert-success"></h2>
			<table id="response" class="table table-bordered"></table>
			<fieldset>
				<legend>Enter your message..</legend>
				<div class="controls">
					<input type="text" class="input-block-level"
						placeholder="Your message..." id="message" style="height: 60px" />
					<input type="submit" class="btn btn-large btn-block btn-primary"
						value="Send message" />
					<button class="btn btn-large btn-block" type="button"
						id="leave-room">Leave room</button>
				</div>
			</fieldset>
		</form>
	</div>
</body>
</html>