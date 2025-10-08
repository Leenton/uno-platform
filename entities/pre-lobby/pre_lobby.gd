extends Node

@onready var name_text_edit := $Control/HBoxContainer/VBoxContainer/HBoxContainer/NameTextEdit
@onready var join_button := $Control/HBoxContainer/VBoxContainer/JoinLobbyButton


func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)

func _on_join_button_pressed() -> void:
	LobbyState.player_info['Name'] = name_text_edit.text
	LobbyState.join_lobby()
