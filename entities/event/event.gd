class_name Event

enum Type { PLAYER_JOINED, GAME_STARTED, CARD_PLAYED, DRAW_REQUESTED, UNO_CALLED, TURN_CHANGED, PENALTY_APPLIED }

var type: int
var source_peer_id: int
var targets: Array[int] = []
var payload: Dictionary = {}

static func make(t: int, src: int, payload := {}, targets := []):
	var e := Event.new()
	e.type = t
	e.source_peer_id = src
	e.payload = payload
	e.targets = targets
	return e
