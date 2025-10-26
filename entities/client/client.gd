extends Node

var current_scene = null
# var lobby_scene
# var table_scene

func _switch_scene(scene: String) -> void:
	if current_scene:
		current_scene.queue_free()

	match scene:
		"pre_lobby":
			current_scene = preload("res://entities/pre-lobby/pre_lobby.tscn").instantiate()
		"lobby":
			current_scene = preload("res://entities/lobby/lobby.tscn").instantiate()
		"table":
			current_scene = preload("res://entities/table-view/table_view.tscn").instantiate()
		_:
			return

	add_child(current_scene)

func _ready() -> void:
	_switch_scene("pre_lobby")

func _process(_delta: float) -> void:
	_read_event_bus()

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
			pass

		Event.Type.PLAYER_JOINED_NON_EXISTENT_TABLE:
			pass

		Event.Type.CLIENT_ENTER_TABLE:
			pass

		# Game events
		Event.Type.GAME_STARTED:
			pass

		# Server data sync events
		Event.Type.UPDATE_CLIENT_PLAYER_LIST:
			var player_list: Array[String] = []
			player_list.assign(e.payload['players'])
			ClientState.players = player_list

		Event.Type.UPDATE_CLIENT_TABLE_LIST:
			_update_table_list(e.payload['tables'])

		Event.Type.CHAT:
			_chat(e)

		null:
			pass

func _update_table_list(tables : Array) -> void:
	var table_list: Array[Dictionary] = []
	for table in tables:
		if typeof(table) == TYPE_DICTIONARY:
			table_list.append(table)

	ClientState.tables = table_list

func _player_name_taken(event : Event):
	pass

func _invalid_player_name(event : Event):
	pass

func _player_enter_lobby(event : Event):
	_update_table_list(event.payload['tables'])
	_switch_scene("lobby")

func _chat(event : Event):
	pass
