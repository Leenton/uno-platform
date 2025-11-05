extends Node

@onready var player_item_list := %PlayerItemList
var player_list = ClientState.players.duplicate(true)

func _process(delta: float) -> void:
	if (player_list != ClientState.players):
		player_list = ClientState.players.duplicate(true)
		
		player_item_list.clear()

		for player in ClientState.players:
			player_item_list.add_icon_item(player)
