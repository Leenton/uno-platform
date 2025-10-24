class_name Event

enum Type {
	PLAYER_CONNECTED,
	PLAYER_NAME_TAKEN,
	INVALID_PLAYER_NAME,
	TABLE_ALREADY_EXISTS,
	PLAYER_JOINED_NON_EXISTENT_TABLE,
	PLAYER_ENTER_LOBBY,
	UPDATE_TABLE_LIST,
	UPDATE_PLAYER_LIST,
	UPDATE_CLIENT_PLAYER_LIST,
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
