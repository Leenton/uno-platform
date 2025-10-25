extends Node

var pre_lobby_scene
var lobby_scene
var table_scene

# var table_scene := preload("res://entities/table/table.tscn")

func load_scenes() -> void:
	pre_lobby_scene = load("res://entities/pre-lobby/pre_lobby.tscn")
	lobby_scene = load("res://entities/lobby/lobby.tscn")
	table_scene = load("res://entities/table/table.tscn")
	
	add_child(pre_lobby_scene.instantiate())

func _process(_delta: float) -> void:
	_read_event_bus()

	

	# Other per-frame client logic can go here

func _read_event_bus() -> void:
	var e = EventBus.read()
	if not e:
		return

	match(e.type):
		# Pre-lobby events
		Event.Type.PLAYER_NAME_TAKEN: _player_name_taken(e)
		Event.Type.INVALID_PLAYER_NAME: _invalid_player_name(e)
		Event.Type.PLAYER_ENTER_LOBBY: _player_enter_lobby(e)

		# Lobby events


		# Table events		
		Event.Type.TABLE_ALREADY_EXISTS:
			LobbyState.game_started()

		Event.Type.PLAYER_JOINED_NON_EXISTENT_TABLE:
			LobbyState.game_started()

		Event.Type.CLIENT_ENTER_TABLE:
			LobbyState.game_started()

		# Game events
		Event.Type.GAME_STARTED:
			LobbyState.game_started()
		
		# Server data sync events
		Event.Type.UPDATE_CLIENT_PLAYER_LIST:
			ClientState.players = e.payload['players']

		Event.Type.UPDATE_CLIENT_TABLE_LIST:
			ClientState.tables = e.payload['tables']

		Event.Type.CHAT:
			_chat(e)

		null:
			pass

func _player_name_taken(event : Event):
	pass

func _invalid_player_name(event : Event):
	pass

func _player_enter_lobby(event : Event):
	ClientState.tables = event.payload['tables']
	

	# pre_lobby_scene.
	
	# LobbyState.enter_lobby(event.payload['tables'])

	# add_child(load("res://entities/lobby/lobby.tscn").instantiate())


func _chat(event : Event):
	pass
	# LobbyState.game_started()
