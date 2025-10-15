extends Node

@export var server_mode = false
@export var debug_ip = ""


func _ready() -> void:
	LobbyState.server_address = debug_ip
