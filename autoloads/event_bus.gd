extends Node

var queue: Array[Event] = []
var is_server: bool = false

func push(type: Event.Type, payload: Dictionary, targets: Array = []) -> void:
	var event: Event = Event.make(type, payload, targets)

	if is_server:
		event.source = 1
		for target in event.targets:
			if multiplayer.has_multiplayer_peer() and multiplayer.get_peers().has(target as int):
				_client_append.rpc_id(target, event.serialise())
				print("Server pushed event")
	else:
		event.source = multiplayer.get_unique_id()
		_client_push.rpc_id(1, event.serialise())

@rpc("authority", "reliable")
func _client_append(e: Dictionary) -> void:
	queue.append(Event.deserialise(e))


# TODO Consider validating e before adding it to the queue?
@rpc("any_peer", "reliable")
func _client_push(e: Dictionary) -> void:
	var event := Event.deserialise(e)
	if event:
		queue.append(event)

func read() -> Event:
	var event = queue.pop_front()
	if event == null:
		event = Event.make(Event.Type.NULL, {})
	return event
