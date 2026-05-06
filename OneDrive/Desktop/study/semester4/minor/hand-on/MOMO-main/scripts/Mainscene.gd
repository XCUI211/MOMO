extends Node2D

const CUTSCENE_SCENE := "res://scenes/Cutscene.tscn"

@onready var value_label: Label = $HUD/ValueLabel
@onready var dialogue_layer: CanvasLayer = $DialogueLayer
@onready var npc_a: Area2D = $NPC_A
@onready var npc_b: Area2D = $NPC_B
@onready var npc_c: Area2D = $NPC_C
@onready var npc_d: Area2D = $NPC_D
@onready var dialogue_box = $DialogueLayer/DialogueBox
@onready var all_talked_panel: Panel = $HUD/AllTalkedPanel
@onready var all_talked_hint: Label = $HUD/AllTalkedPanel/AllTalkedHint

var _dialogue_open := false
var _transitioning := false

func _ready() -> void:
	all_talked_panel.visible = false
	_refresh_value_label()
	GlobalState.value_changed.connect(_on_value_changed)
	GlobalState.all_npcs_talked.connect(_on_all_npcs_talked)
	npc_a.connect("npc_clicked", _on_npc_clicked)
	npc_b.connect("npc_clicked", _on_npc_clicked)
	npc_c.connect("npc_clicked", _on_npc_clicked)
	npc_d.connect("npc_clicked", _on_npc_clicked)
	dialogue_box.connect("dialogue_closed", _on_dialogue_closed)

func _stop_all_bgm() -> void:
	var audio := get_node_or_null("/root/AudioManager")
	if audio == null:
		return
	for child in audio.get_children():
		if child is AudioStreamPlayer or child is AudioStreamPlayer2D:
			child.stop()

func play_npc_bgm(npc_id: String) -> void:
	_stop_all_bgm()
	var audio := get_node_or_null("/root/AudioManager")
	if audio == null:
		return
	var bgm_map := {
		"npc_a": "npcABgm",
		"npc_b": "npcBBgm",
		"npc_c": "npcCBgm",
		"npc_d": "npcDBgm",
	}
	if npc_id in bgm_map:
		var bgm = audio.get_node_or_null(bgm_map[npc_id])
		if bgm_map[npc_id] == "npcCBgm":
			bgm.play(31.0)
		else:
			bgm.play()

func play_main_bgm() -> void:
	_stop_all_bgm()
	var audio := get_node_or_null("/root/AudioManager")
	if audio == null:
		return
	var main_bgm = audio.get_node_or_null("BGM")
	if main_bgm:
		main_bgm.play()

func _on_npc_clicked(npc_id: String, knot_name: String) -> void:
	if _dialogue_open or _transitioning:
		return
	if GlobalState.npc_talked.get(npc_id, false):
		return
	_dialogue_open = true
	play_npc_bgm(npc_id)
	dialogue_box.open_dialogue(npc_id, knot_name)

func _on_dialogue_closed(npc_id: String) -> void:
	_dialogue_open = false
	GlobalState.mark_npc_talked(npc_id)
	play_main_bgm()

func _on_value_changed(_new_val: int) -> void:
	_refresh_value_label()

func _refresh_value_label() -> void:
	value_label.text = "Stolen Time: %d" % GlobalState.stolen_time

func _on_all_npcs_talked() -> void:
	if _transitioning:
		return
	_transitioning = true
	all_talked_hint.text = "You have stolen as much time as you could from the residents.\nIt is time to meet Momo."
	all_talked_panel.visible = true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file(CUTSCENE_SCENE)
