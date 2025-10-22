class_name Player

enum ConnectionStatus {
	CONNECTED,
	DISCONNECTED
} 

var name: String
var connection_status: ConnectionStatus = ConnectionStatus.DISCONNECTED
var id: int


func send_join(name: String) -> void:
	pass
	#(1, "client_intent", Event.Type.PLAYER_JOINED, { "name": name })
