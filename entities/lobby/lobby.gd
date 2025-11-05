extends Node

@onready var table_name_text_edit := %TableNameTextEdit
@onready var create_table_button := %CreateTableButton

func _ready() -> void:
	create_table_button.pressed.connect(_on_create_table_button_pressed)

func _on_create_table_button_pressed() -> void:
	var table_name: String = table_name_text_edit.text.strip_edges()

	if(len(table_name) == 0 ):
		return

	EventBus.push(
		Event.Type.CREATE_TABLE,
		{'table_name' : table_name}
	)

func _process(delta: float) -> void:
	pass
