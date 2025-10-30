extends Node

var players: Array[String] = []
var tables: Array[Dictionary] = []

var player_name: String
var current_table: Dictionary = {}
var config := ConfigFile.new()

func _ready() -> void:
	config.load('user://config.cfg')
	player_name = config.get_value('player', 'name', '')

func set_player_name_value(n: String) -> void:
	config.set_value('player', 'name', n)
	if config.save('user://config.cfg') != OK:
		push_error('Failed to save player name to config file.')

	player_name = n
