class_name Event

enum Type {
	# Server side events
	PLAYER_CONNECTED,
	CREATE_TABLE,
	JOIN_TABLE,
	SET_RULES,
	START_GAME,
	ABORT_GAME,
	DELETE_TABLE,
	PLAY_CARD,
	DRAW_CARD,
	CALL_OUT_UNO,
	REORDER_CARDS,
	FOCUS_ON_CARD,
	CHAT,

	# Client side events
	PLAYER_NAME_TAKEN,
	INVALID_PLAYER_NAME,
	TABLE_ALREADY_EXISTS,
	PLAYER_JOINED_NON_EXISTENT_TABLE,
	PLAYER_ENTER_LOBBY,
	UPDATE_CLIENT_PLAYER_LIST,
	UPDATE_CLIENT_TABLE_LIST,
	CLIENT_ENTER_TABLE,
	GAME_STARTED,
	CARD_PLAYED,
	DRAW_REQUESTED,
	UNO_CALLED,
	TURN_CHANGED,
	PENALTY_APPLIED
}

var type: int
var source: int
var targets: Array[int] = []
var payload: Dictionary = {}

static func make(event_type: int, event_payload := {}, event_targets := []) -> Event:
	var e := Event.new()
	e.type = event_type
	e.payload = event_payload
	e.targets = event_targets

	return e

func serialise() -> Dictionary:
	return {
		"type": type,
		"source": source,
		"targets": targets,
		"payload": payload
	}

static func deserialise(e: Dictionary) -> Event:
	var event := Event.new()
	event.type = e['type']
	event.source = e['source']
	event.payload = e['payload']
	event.targets = e['targets']

	return event
