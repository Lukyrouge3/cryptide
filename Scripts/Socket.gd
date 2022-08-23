extends Node

export var websocket_url = "ws://localhost:8080"

var client = WebSocketClient.new();

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	client.connect("connection_closed", self, "_closed")
	client.connect("connection_error", self, "_closed")
	client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	client.connect("data_received", self, "_on_data")
 
	# Initiate connection to the given URL.
	var err = client.connect_to_url(websocket_url)
	if err != OK:
		 print("Unable to connect")
		 set_process(false)
	
	var msg = Message.new("test", {});
	print(msg.toJSON(), msg.toString());
	var lambda = test();
	print(typeof(lambda));

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
		# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_data():
	var msg = Message.parse(client.get_peer(1).get_packet().get_string_from_utf8());
	print("Received: ", msg.type, msg.data);

func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	client.poll()

func send(msg):
	client.get_peer(1).put_packet(msg.toString());
	print("Sent: ", msg.type);

class Message:

	var type: String;
	var data: Dictionary;

	func _init(_type: String, _data: Dictionary):
		type = _type;
		data = _data;

	func toJSON() -> JSON:
		return JSON.parse(self.toString()).result;

	func toString() -> String:
		return "{\"type\": \"" + type + "\", \"data\":" + JSON.print(data) +"}";

	static func parse(msg) -> Message:
		var o = JSON.parse(msg).result;
		return Message.new(o.type, o.data);

class MessageHandler:
	var handlers = {}; # type -> Function

	var client: WebSocketClient;

	func _init(_client):
		client = _client;

	func defaultHandler(msg):
		print("Unhandled message: ", msg.type);

	# func registerHandler(_type: String, _func: Function):
	# 	handlers[_type] = _func;

	func handle(_msg):
		if _msg.type in handlers:
			# var f: Function = handlers[_msg.type];
			# f(_msg);
			pass;
		else:
			defaultHandler(_msg);

func test():
	pass;
