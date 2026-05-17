extends Node2D

const CUTSCENE_SCENE := "res://scenes/Cutscene.tscn"

const START_PROMPT_TEXT := "Who would you like to talk with?"
const END_PROMPT_TEXT := "You think you already stole time as much as you can. Time to meet Momo."
const TIME_BAR_SIZE := Vector2(260, 16)
const TIME_BAR_OFFSET := Vector2(0, 32)
const TIME_ICON_OFFSET := Vector2(-34, -2)

@onready var value_label: Label = $HUD/ValueLabel
@onready var dialogue_layer: CanvasLayer = $DialogueLayer
@onready var npc_a: Area2D = $NPC_A
@onready var npc_b: Area2D = $NPC_B
@onready var npc_c: Area2D = $NPC_C
@onready var npc_d: Area2D = $NPC_D
@onready var dialogue_box = $DialogueLayer/DialogueBox

var _dialogue_open := false
var _transitioning := false
var _time_bar: ProgressBar
var _time_icon: Label
var _time_bar_tween: Tween


func _ready() -> void:
	play_main_bgm()
	_setup_time_hud()
	_refresh_value_label()

	GlobalState.value_changed.connect(_on_value_changed)
	GlobalState.all_npcs_talked.connect(_on_all_npcs_talked)

	npc_a.connect("npc_clicked", _on_npc_clicked)
	npc_b.connect("npc_clicked", _on_npc_clicked)
	npc_c.connect("npc_clicked", _on_npc_clicked)
	npc_d.connect("npc_clicked", _on_npc_clicked)

	dialogue_box.connect("dialogue_closed", _on_dialogue_closed)
	dialogue_box.connect("system_prompt_clicked", _on_system_prompt_clicked)

	dialogue_box.show_system_prompt(START_PROMPT_TEXT, false)


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
		if bgm == null:
			return

		if npc_id == "npc_d":
			bgm.play(6.0)
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
	dialogue_box.hide_system_prompt()
	play_npc_bgm(npc_id)
	dialogue_box.open_dialogue(npc_id, knot_name)


func _on_dialogue_closed(npc_id: String) -> void:
	_dialogue_open = false
	GlobalState.mark_npc_talked(npc_id)
	play_main_bgm()

	if not _transitioning:
		dialogue_box.show_system_prompt(START_PROMPT_TEXT, false)


func _on_value_changed(_new_val: int) -> void:
	_refresh_value_label()


func _setup_time_hud() -> void:
	var hud_parent := value_label.get_parent()

	_time_icon = Label.new()
	_time_icon.name = "TimeIcon"
	_time_icon.text = "⌛"
	_time_icon.position = value_label.position + TIME_ICON_OFFSET
	_time_icon.add_theme_font_size_override("font_size", 24)
	hud_parent.add_child(_time_icon)

	_time_bar = ProgressBar.new()
	_time_bar.name = "StolenTimeBar"
	_time_bar.show_percentage = false
	_time_bar.min_value = -GlobalState.max_value
	_time_bar.max_value = GlobalState.max_value
	_time_bar.value = GlobalState.stolen_time
	_time_bar.position = value_label.position + TIME_BAR_OFFSET
	_time_bar.custom_minimum_size = TIME_BAR_SIZE
	_time_bar.size = TIME_BAR_SIZE
	hud_parent.add_child(_time_bar)

	_update_time_bar_style()


func _refresh_value_label() -> void:
	value_label.text = "Stolen Time（your cigar）: %d" % GlobalState.stolen_time

	if _time_bar == null:
		return

	if _time_bar_tween != null and _time_bar_tween.is_valid():
		_time_bar_tween.kill()

	_time_bar_tween = create_tween()
	_time_bar_tween.tween_property(_time_bar, "value", GlobalState.stolen_time, 0.18)
	_update_time_bar_style()


func _update_time_bar_style() -> void:
	if _time_bar == null:
		return

	var ratio := inverse_lerp(float(-GlobalState.max_value), float(GlobalState.max_value), float(GlobalState.stolen_time))
	var fill_color := Color("#8fb8ff")
	if ratio >= 0.66:
		fill_color = Color("#ff5a42")
	elif ratio >= 0.33:
		fill_color = Color("#f4c542")

	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.08, 0.07, 0.06, 0.82)
	bg_style.border_color = Color(0.45, 0.36, 0.24, 0.95)
	bg_style.set_border_width_all(1)
	bg_style.set_corner_radius_all(8)

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = fill_color
	fill_style.set_corner_radius_all(8)

	_time_bar.add_theme_stylebox_override("background", bg_style)
	_time_bar.add_theme_stylebox_override("fill", fill_style)

	if _time_icon != null:
		_time_icon.text = "⌛" if GlobalState.stolen_time < GlobalState.max_value else "⏳"
		_time_icon.add_theme_color_override("font_color", fill_color)


func _on_all_npcs_talked() -> void:
	if _transitioning:
		return

	_transitioning = true
	dialogue_box.show_system_prompt(END_PROMPT_TEXT, true)


func _on_system_prompt_clicked() -> void:
	if not _transitioning:
		return

	get_tree().change_scene_to_file(CUTSCENE_SCENE)
