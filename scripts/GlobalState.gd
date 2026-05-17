extends Node

signal value_changed(new_val: int)
signal all_npcs_talked

var stolen_time := 0
var max_value := 100
var battle_won := false

var npc_talked: Dictionary = {
	"npc_a": false,
	"npc_b": false,
	"npc_c": false,
	"npc_d": false,
}

func change_value(delta: int) -> void:
	stolen_time = clampi(stolen_time + delta, -max_value, max_value)
	value_changed.emit(stolen_time)

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
	battle_won = false

	for key in npc_talked:
		npc_talked[key] = false

	value_changed.emit(stolen_time)

func _check_all_talked() -> void:
	if all_talked():
		all_npcs_talked.emit()
