extends Control

signal dialogue_closed(npc_id: String)

const CHAR_DELAY := 0.01

const NPC_BACKGROUNDS := {
	"npc_a": "res://materials/IMG_2971.png",
	"npc_b": "res://materials/IMG_2970.png",
	"npc_c": "res://materials/IMG_2968.png",
	"npc_d": "res://materials/IMG_2969.png",
}
const NPC_PORTRAITS := {
	"npc_a": "res://materials/IMG_2947.png",
	"npc_b": "res://materials/IMG_2948.png",
	"npc_c": "res://materials/IMG_2949.png",
	"npc_d": "res://materials/IMG_2950.png",
}
const NPC_NAMES := {
	"npc_a": "Bepoo",
	"npc_b": "Nino",
	"npc_c": "Baker",
	"npc_d": "Barber",
}

@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/NameLabel
@onready var text_label: RichTextLabel = $Panel/TextLabel
@onready var continue_hint: Label = $Panel/ContinueHint
@onready var choices_container: VBoxContainer = $ChoicesContainer
@onready var dialogue_bg: TextureRect = $DialogueBackground
@onready var portrait: TextureRect = $CharacterPortrait

var _current_npc_id := ""
var _waiting_choice := false
var _text_animating := false
var _pending_choices: Array = []
var _story_ended := false       

func _ready() -> void:
	visible = false
	InkManager.story_continued.connect(_on_story_continued)
	InkManager.choices_available.connect(_on_choices_available)
	InkManager.story_ended.connect(_on_story_ended)

func open_dialogue(npc_id: String, knot_name: String) -> void:
	_current_npc_id = npc_id
	_waiting_choice = false
	_story_ended = false          
	name_label.text = NPC_NAMES.get(npc_id, npc_id)
	text_label.text = ""
	continue_hint.visible = false
	_clear_choices()
	visible = true

	var bg_path: String = NPC_BACKGROUNDS.get(npc_id, "")
	if not bg_path.is_empty():
		dialogue_bg.texture = load(bg_path)

	var portrait_path: String = NPC_PORTRAITS.get(npc_id, "")
	if not portrait_path.is_empty():
		portrait.texture = load(portrait_path)
		portrait.visible = true
	else:
		portrait.visible = false

	InkManager.start_npc_dialogue(npc_id)
	InkManager.start_knot(knot_name)

func _input(event: InputEvent) -> void:
	if not visible or _waiting_choice:
		return

	var clicked := false
	if event is InputEventMouseButton:
		clicked = event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var confirmed := false
	if event is InputEventKey:
		confirmed = (event.keycode == KEY_SPACE or event.keycode == KEY_ENTER) and event.pressed

	if not (clicked or confirmed):
		return

	if _text_animating:
		_text_animating = false
		return

	if _story_ended:
		_close()
		return

	InkManager.continue_story()

func _on_story_continued(text: String, _tags: Array) -> void:
	_waiting_choice = false
	_story_ended = false
	_clear_choices()
	continue_hint.visible = false
	_play_typewriter(text.strip_edges())

func _on_choices_available(choices: Array) -> void:
	_waiting_choice = true
	continue_hint.visible = false
	if _text_animating:
		_pending_choices = choices
	else:
		_show_choices(choices)

func _on_story_ended() -> void:
	_story_ended = true

func _play_typewriter(full_text: String) -> void:
	_text_animating = true
	_pending_choices = []
	text_label.text = ""
	for i in range(full_text.length() + 1):
		if not is_inside_tree():         
			_text_animating = false
			return
		if not _text_animating:
			text_label.text = full_text
			break
		text_label.text = full_text.substr(0, i)
		await get_tree().create_timer(CHAR_DELAY).timeout
	_text_animating = false

	if not is_inside_tree():              
		return

	if _pending_choices.size() > 0:
		_show_choices(_pending_choices)
		_pending_choices = []
	elif _story_ended:
		continue_hint.text = "[ Click to close ]"
		continue_hint.visible = true
	elif not _waiting_choice:
		continue_hint.text = "▼"
		continue_hint.visible = true

	if _pending_choices.size() > 0:
		_show_choices(_pending_choices)
		_pending_choices = []
	elif _story_ended:
		continue_hint.text = "[ Click to close ]"
		continue_hint.visible = true
	elif not _waiting_choice:
		continue_hint.text = "▼"
		continue_hint.visible = true

func _show_choices(choices: Array) -> void:
	_clear_choices()
	for i in range(choices.size()):
		var btn := Button.new()
		btn.text = choices[i].text
		btn.pressed.connect(_on_choice_pressed.bind(i))
		choices_container.add_child(btn)

func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()

func _on_choice_pressed(index: int) -> void:
	_clear_choices()
	_waiting_choice = false
	InkManager.make_choice(index)

func _close() -> void:
	visible = false
	dialogue_closed.emit(_current_npc_id)
	_current_npc_id = ""
	_story_ended = false
