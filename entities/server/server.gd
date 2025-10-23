extends Node

const Table = preload("res://entities/table/table.gd")

func _ready():
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(ServerState.PORT, ServerState.MAX_CONNECTIONS)

	if error:
		return error
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id):
	print("Client connected: %s" % id)

func _on_peer_disconnected(id):
	ServerState.players[id].connection_status = Player.ConnectionStatus.DISCONNECTED
	_update_player_list_for_clients()

func _process(_delta: float) -> void:
	var e = EventBus.read()
	if not e:
		return

	match(e.type):
		Event.Type.PLAYER_CONNECTED:
			_player_connected(e)
		null:
			pass

func _player_connected(event : Event):
	# Validate player name
	if event.payload['name'].strip_edges().length() == 0:
		EventBus.push(Event.Type.INVALID_PLAYER_NAME, {}, [event.source])
		return

	# Check if the player name is already taken by a connected player
	var existing_player = ServerState.get_player_by_name(event.payload['name'])

	if existing_player and existing_player.connection_status == Player.ConnectionStatus.CONNECTED:
		EventBus.push(Event.Type.PLAYER_NAME_TAKEN, {}, [event.source])
		return

	# Check if the player name belongs to a disconnected player
	if existing_player and existing_player.connection_status == Player.ConnectionStatus.DISCONNECTED:
		existing_player.id = event.source
		_update_player_list_for_clients()

		# If the player was in a game, re-add them to it
		if existing_player.table_id:
			# EventBus.push(
			# 	Event.Type.CLIENT_ENTER_TABLE,
			# 	{"table_state": ServerState.tables[existing_player.table_id]},
			# 	[event.source]
			# )

			return

	else:
		# Add the new player
		ServerState.players[event.source] = Player.make(event.payload['name'], event.source)
		_update_player_list_for_clients()

	EventBus.push(Event.Type.PLAYER_ENTER_LOBBY, {"tables": ServerState.get_tables_for_lobby_screen()}, [event.source])

func _update_player_list_for_clients():
	EventBus.push(
		Event.Type.UPDATE_CLIENT_PLAYER_LIST,
		{"players": ServerState.get_connected_players().map(func(p): return p.name)},
		ServerState.get_connected_players().map(func(p): return p.id)
	)


func _create_table(event : Event):
	ServerState.tables.append(Table.make(
		event.payload["table_name"],
		{},
		{},
		[],
		12,
		"Waiting to start game"
	))

	EventBus.push(
		Event.Type.UPDATE_TABLE_LIST,
		{
			"tables": ServerState.tables
		},
		ServerState.players.keys()
	)	

	EventBus.push(
		Event.Type.CLIENT_ENTER_TABLE,
		{
			"table_state": ServerState.tables[event.payload["table_name"]]
		},
		[event.source]
	)
