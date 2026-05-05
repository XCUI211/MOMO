extends Node

var stolen_time: int = 0      
var max_value:    int = 100      

var npc_talked: Dictionary = {
	"npc_a": false,
	"npc_b": false,
	"npc_c": false,
	"npc_d": false,
}

var battle_won: bool = false     

signal value_changed(new_val)         
signal all_npcs_talked                


func change_value(delta: int) -> void:
	stolen_time = clamp(stolen_time + delta, 0, max_value)
	emit_signal("value_changed", stolen_time)

func mark_npc_talked(npc_id: String) -> void:
	if npc_id in npc_talked:
		npc_talked[npc_id] = true
	_check_all_talked()

func all_talked() -> bool:
	for key in npc_talked:
		if not npc_talked[key]:
			return false
	return true

func reset() -> void:
	stolen_time = 0
	battle_won   = false
	for key in npc_talked:
		npc_talked[key] = false

func _check_all_talked() -> void:
	if all_talked():
		emit_signal("all_npcs_talked")
