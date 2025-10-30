extends Node

@onready var player_list_vbox := $VBoxContainer

func _ready() -> void:
	pass
	# LobbyState.updated_lobby_player_list.connect(update_player_list)

func update_player_list():	
	for child in player_list_vbox.get_children():
		child.queue_free()
