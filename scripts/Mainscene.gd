extends Node2D

onready var value_label     : Label       = $HUD/ValueLabel
onready var dialogue_layer  : CanvasLayer = $DialogueLayer
onready var npc_a           : Area2D      = $NPC_A
onready var npc_b           : Area2D      = $NPC_B
onready var npc_c           : Area2D      = $NPC_C
onready var npc_d           : Area2D      = $NPC_D

const CUTSCENE_SCENE := "res://scenes/Cutscene.tscn"

var _dialogue_open: bool = false  

func _ready() -> void:
	_refresh_value_label()

	GlobalState.connect("value_changed",    self, "_on_value_changed")

	GlobalState.connect("all_npcs_talked",  self, "_on_all_npcs_talked")

	npc_a.connect("npc_clicked", self, "_on_npc_clicked")
	npc_b.connect("npc_clicked", self, "_on_npc_clicked")
	npc_c.connect("npc_clicked", self, "_on_npc_clicked")
	npc_d.connect("npc_clicked", self, "_on_npc_clicked")

	dialogue_layer.get_node("DialogueBox").connect(
		"dialogue_closed", self, "_on_dialogue_closed"
	)

func _on_npc_clicked(npc_id: String, knot_name: String) -> void:
	if _dialogue_open:
		return
	if GlobalState.npc_talked[npc_id]:
		return
	_dialogue_open = true
	dialogue_layer.get_node("DialogueBox").open_dialogue(npc_id, knot_name)

func _on_dialogue_closed(npc_id: String) -> void:
	_dialogue_open = false
	GlobalState.mark_npc_talked(npc_id)  

func _on_value_changed(new_val: int) -> void:
	_refresh_value_label()

func _refresh_value_label() -> void:
	value_label.text = "Score: %d" % GlobalState.stolen_time

func _on_all_npcs_talked() -> void:
	$HUD/AllTalkedHint.text = "You have talked to all residents. \n Click anywhere to continue……"
	$HUD/AllTalkedHint.visible = true
	yield(get_tree().create_timer(0.3), "timeout")
	yield(get_tree(), "idle_frame")
	get_tree().change_scene("res://scenes/Cutscene.tscn")
