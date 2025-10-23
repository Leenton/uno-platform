class_name Table

var name: String
var players: Dictionary = {}
var spectators: Dictionary = {}
var rules: Array = []
var max_players: int = 12
var state: String = "Waiting to start game"

static func make(
    table_name: String,
    table_players: Dictionary,
    table_spectators: Dictionary,
    table_rules: Array,
    table_max_players: int,
    table_state: String
) -> Table:
    var t := Table.new()
    t.name = table_name
    t.players = table_players
    t.spectators = table_spectators
    t.rules = table_rules
    t.max_players = table_max_players
    t.state = table_state
    return t