class_name Player

enum ConnectionStatus {
	CONNECTED,
	DISCONNECTED
} 

var name: String
var connection_status: ConnectionStatus = ConnectionStatus.DISCONNECTED
var id: int
var table_id: int

static func make(player_name: String, player_id: int):
	var p := Player.new()
	p.name = player_name
	p.connection_status = Player.ConnectionStatus.CONNECTED
	p.id = player_id

	return p