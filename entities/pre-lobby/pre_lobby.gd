extends Node

@onready var name_text_edit := $Control/HBoxContainer/VBoxContainer/HBoxContainer/NameTextEdit
@onready var join_button := $Control/HBoxContainer/VBoxContainer/JoinLobbyButton

func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)

func _on_join_button_pressed() -> void:
	var player_name : String = name_text_edit.text.strip_edges()
	
	if (len(player_name) == 0):
		return

	LobbyState.join_lobby()
	
	add_child(load("res://entities/lobby/lobby.tscn").instantiate())
