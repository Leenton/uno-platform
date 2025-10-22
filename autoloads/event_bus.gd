extends Node

var queue: Array[Event] = []

func push(e: Event) -> void:
	queue.append(e)

func read() -> Event:
	return queue.pop_front()
