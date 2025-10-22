extends Node

@onready var table_name_text_edit := $Control/HBoxContainer/VBoxContainer/HBoxContainer/TableNameTextEdit
@onready var create_table_button := $Control/HBoxContainer/VBoxContainer/CreateTableButton

func _ready() -> void:
	create_table_button.pressed.connect(_on_create_table_button_pressed)
	add_child(load("res://entities/lobby-player-list/lobby_player_list.tscn").instantiate())

func _on_create_table_button_pressed() -> void:
	var table_name: String = table_name_text_edit.text.strip_edges()

	if(len(table_name) == 0 ):
		return
	
	elif (table_name.to_lower() in LobbyState.tables.keys().map(func(table): return table.to_lower())):
		return

	LobbyState.create_table(table_name)
 

func _process(delta: float) -> void:
	pass
