extends Node

@onready var player_list_vbox := $VBoxContainer

func _ready() -> void:
	LobbyState.updated_lobby_player_list.connect(update_player_list)

func update_player_list():	
	for child in player_list_vbox.get_children():
		child.queue_free()

	print(player_list_vbox.get_child_count())
	for player: String in LobbyState.players.keys():
		var label := Label.new()
		player_list_vbox.add_child(label)
		label.text = player
