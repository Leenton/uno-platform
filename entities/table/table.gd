class_name Table

var name: String
var players: Array[String] = []
var spectators: Array[String] = []

var state: Table.State
var creator: String
var password : String = ""


var draw_to_play: bool = true
var play_at_draw: bool = false
var jump_in_allowed: bool = true
var stack_cards: bool = true
var swap_on_seven: bool = false
var swap_on_zero: bool = false
var max_players: int = 10
var spectators_can_see_cards: bool = false
var time_per_turn: int = 30

var game_data: Dictionary = {
}

enum State {
	WAITING,
	IN_PROGRESS,
	PAUSED,
	COMPLETED
}

static func make(
	table_name: String,
	table_players: Array[String],
	table_spectators: Array[String],
	table_rules: Dictionary,
	table_creator: String
) -> Table:
	var t := Table.new()
	t.name = table_name
	t.players = table_players
	t.spectators = table_spectators
	t.rules = table_rules
	t.state = Table.State.WAITING
	t.creator = table_creator
	t.spectators_can_see_cards = false
	return t

func get_data():
	return {
		"name": name,
		"players": players,
		"spectators": spectators,
		"spectators_can_see_cards": spectators_can_see_cards,
		"draw_to_play": draw_to_play,
		"play_at_draw": play_at_draw,
		"jump_in_allowed": jump_in_allowed,
		"stack_cards": stack_cards,
		"swap_on_seven": swap_on_seven,
		"swap_on_zero": swap_on_zero,
		"max_players": max_players,
		"state": state,
		"creator": creator,
		"game_data": game_data
	}
