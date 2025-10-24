extends Node

@export var server_mode = false
@export var debug_ip = ""
@export var debug_port = ""

func _ready() -> void:
	if debug_ip:
		ServerState.server_address = debug_ip
