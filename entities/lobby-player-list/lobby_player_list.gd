extends Node

@onready var player_list_vbox := $VBoxContainer
var player_list = ClientState.players.duplicate(true)

func _process(delta: float) -> void:
	if (player_list != ClientState.players):
		player_list = ClientState.players.duplicate(true)

		for child in player_list_vbox.get_children():
			child.queue_free()

		for player in ClientState.players:
			#SOmething that creates  an element representing that particular user
			pass
