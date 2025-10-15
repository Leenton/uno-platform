class_name Player

enum ConnectionStatus {
	CONNECTED,
	DISCONNECTED
} 

var name: String
var connection_status: ConnectionStatus = ConnectionStatus.DISCONNECTED
var id: int
