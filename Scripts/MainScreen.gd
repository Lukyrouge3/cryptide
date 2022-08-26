extends Control

signal createRoom;

func _on_CreateRoomButton_pressed():
	emit_signal("createRoom");


func _on_JoinRoomButton_pressed():
	pass # Replace with function body.
