extends Node2D

const BATTLE_SCENE := "res://src/scenes/Battle.tscn"
const DIALOGUE_FONT := preload("res://fonts/NESCyrillic.ttf")

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var dialogue_panel: Panel
var name_label: Label
var text_label: Label
var continue_label: Label

var dialogue_index := 0
var current_text := ""
var typed_count := 0
var is_typing := false
var typing_speed := 0.035

var boss_dialogue := [
	{"name": "Momo", "text": "You finally came."},
	{"name": "Momo", "text": "All the stolen time led you here."},
	{"name": "Momo", "text": "I will protexxt the people I love and our precious time. I will defeat you."}
]

func _ready() -> void:
	if has_node("CanvasLayer/FadeRect"):
		$CanvasLayer/FadeRect.hide()

	create_dialogue_box()
	show_next_dialogue()

func create_dialogue_box() -> void:
	dialogue_panel = Panel.new()
	dialogue_panel.anchor_left = 0.1
	dialogue_panel.anchor_top = 0.7
	dialogue_panel.anchor_right = 0.9
	dialogue_panel.anchor_bottom = 0.95
	canvas_layer.add_child(dialogue_panel)

	name_label = Label.new()
	name_label.position = Vector2(24, 16)
	name_label.add_theme_font_override("font", DIALOGUE_FONT)
	name_label.add_theme_font_size_override("font_size", 24)
	dialogue_panel.add_child(name_label)

	text_label = Label.new()
	text_label.position = Vector2(24, 58)
	text_label.size = Vector2(850, 90)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.add_theme_font_override("font", DIALOGUE_FONT)
	text_label.add_theme_font_size_override("font_size", 22)
	dialogue_panel.add_child(text_label)

	continue_label = Label.new()
	continue_label.text = "Click / Enter to continue"
	continue_label.position = Vector2(650, 130)
	continue_label.add_theme_font_override("font", DIALOGUE_FONT)
	continue_label.add_theme_font_size_override("font_size", 16)
	dialogue_panel.add_child(continue_label)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.pressed:
		if is_typing:
			finish_typing()
		else:
			show_next_dialogue()

func show_next_dialogue() -> void:
	if dialogue_index >= boss_dialogue.size():
		get_tree().change_scene_to_file(BATTLE_SCENE)
		return

	var line = boss_dialogue[dialogue_index]
	dialogue_index += 1

	name_label.text = line["name"]
	start_typing(line["text"])

func start_typing(text: String) -> void:
	current_text = text
	typed_count = 0
	text_label.text = ""
	continue_label.hide()
	is_typing = true

	while typed_count < current_text.length() and is_typing:
		typed_count += 1
		text_label.text = current_text.substr(0, typed_count)
		await get_tree().create_timer(typing_speed).timeout

	if is_typing:
		finish_typing()

func finish_typing() -> void:
	is_typing = false
	text_label.text = current_text
	continue_label.show()
