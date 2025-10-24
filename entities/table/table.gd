class_name Table

var name: String
var players: Array[String] = []
var spectators: Array[String] = []
var rules: Dictionary = {}
var max_players: int = 12
var state: Table.State
var creator: String
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

    return t

func get_data():
    return []