extends Control


signal dialogue_closed(npc_id)   

onready var panel             : Panel          = $Panel
onready var name_label        : Label          = $Panel/NameLabel
onready var text_label        : RichTextLabel  = $Panel/TextLabel
onready var continue_hint     : Label          = $Panel/ContinueHint
onready var choices_container : VBoxContainer  = $ChoicesContainer

var _current_npc_id   : String = ""
var _waiting_choice   : bool   = false     
var _text_animating   : bool   = false    
onready var dialogue_bg: TextureRect = $DialogueBackground

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
onready var portrait: TextureRect = $CharacterPortrait
const CHAR_DELAY := 0.06

const NPC_NAMES := {
	"npc_a": "Bepoo",
	"npc_b": "Nino",
	"npc_c": "Baker",
	"npc_d": "Barber",
}

func _ready() -> void:
	visible = false

	InkManager.connect("story_continued",   self, "_on_story_continued")
	InkManager.connect("choices_available", self, "_on_choices_available")
	InkManager.connect("story_ended",       self, "_on_story_ended")

# DialogueBox.gd

func open_dialogue(npc_id: String, knot_name: String) -> void:
	_current_npc_id   = npc_id
	_waiting_choice   = false
	name_label.text   = NPC_NAMES.get(npc_id, npc_id)
	text_label.bbcode_text = ""
	continue_hint.visible  = false

	_clear_choices()
	visible = true
	var bg_path = NPC_BACKGROUNDS.get(npc_id, "")
	if bg_path != "":
		dialogue_bg.texture = load(bg_path)
	

	InkManager.start_npc_dialogue(npc_id) 
	
	InkManager.start_knot(knot_name)
	var portrait_path = NPC_PORTRAITS.get(npc_id, "")
	if portrait_path != "":
		portrait.texture = load(portrait_path)
		portrait.visible = true
	else:
		portrait.visible = false
		
func _input(event: InputEvent) -> void:
	if not visible:
		return
	if _waiting_choice:
		return

	var clicked = (event is InputEventMouseButton
		and event.button_index == BUTTON_LEFT
		and event.pressed)
	var confirmed = (event is InputEventKey
		and (event.scancode == KEY_SPACE or event.scancode == KEY_ENTER)
		and event.pressed)

	if not (clicked or confirmed):
		return

	if _text_animating:
		_text_animating = false  
		return

	InkManager.continue_story()

func _on_story_continued(text: String, tags: Array) -> void:
	_waiting_choice = false
	_clear_choices()
	continue_hint.visible = false
	_play_typewriter(text.strip_edges())

func _on_choices_available(choices: Array) -> void:
	_waiting_choice = true
	continue_hint.visible = false
	_show_choices(choices)

func _on_story_ended() -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	_close()

func _play_typewriter(full_text: String) -> void:
	_text_animating = true
	text_label.bbcode_text = ""
	for i in range(full_text.length() + 1):
		if not _text_animating:
			text_label.bbcode_text = full_text
			break
		text_label.bbcode_text = full_text.substr(0, i)
		yield(get_tree().create_timer(CHAR_DELAY), "timeout")
	_text_animating = false
	if not _waiting_choice:
		continue_hint.visible = true

func _skip_typewriter() -> void:
	_text_animating = false
	continue_hint.visible = true

# func _play_typewriter_safe(full_text: String) -> void:
#     _text_animating = true
#     text_label.bbcode_text = ""
#     for i in range(full_text.length() + 1):
#         if not _text_animating:
#             text_label.bbcode_text = full_text
#             break
#         text_label.bbcode_text = full_text.substr(0, i)
#         yield(get_tree().create_timer(CHAR_DELAY), "timeout")
#     _text_animating = false
#     if not _waiting_choice:
#         continue_hint.visible = true

func _show_choices(choices: Array) -> void:
	_clear_choices()
	for i in range(choices.size()):
		var btn := Button.new()
		btn.text = choices[i]
		btn.connect("pressed", self, "_on_choice_pressed", [i])
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
	emit_signal("dialogue_closed", _current_npc_id)
	_current_npc_id = ""
