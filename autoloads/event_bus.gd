extends Node

var queue: Array[Event] = []

func push(type: Event.Type, payload: Dictionary, targets: Array[int]) -> void:
	var event: Event = Event.make(type, payload, targets)

	if multiplayer.is_server():
		event.source = 1
		for target in event.targets:
			if multiplayer.has_multiplayer_peer() and multiplayer.get_peers().has(target as int):
				_client_append.rpc_id(target, event.serialise())
	else:
		event.source = multiplayer.get_unique_id()
		_client_push.rpc_id(1, event.serialise())

@rpc("authority", "reliable")
func _client_append(e: Dictionary) -> void:
	queue.append(Event.deserialise(e))

@rpc("any_peer", "reliable")
func _client_push(e: Dictionary) -> void:
	queue.append(Event.deserialise(e))

func read() -> Variant:
	return queue.pop_front()
