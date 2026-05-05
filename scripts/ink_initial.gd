extends Node

signal story_continued(text, tags)
signal choices_available(choices)
signal story_ended

var ink_player = null
var current_npc = ""

var story_loaded = false
var pending_knot = ""

var story_files = {
	"npc_a": preload("res://ink_story/beppo.ink.json"),
	"npc_b": preload("res://ink_story/Nino.ink.json"),
	"npc_c": preload("res://ink_story/baker.ink.json"),
	"npc_d": preload("res://ink_story/barber.ink.json")
}

func _ready():
	ink_player = InkPlayer.new()
	add_child(ink_player)

	ink_player.loads_in_background = false

	ink_player.connect("loaded", self, "_on_story_loaded")
	ink_player.connect("continued", self, "_on_continued")
	ink_player.connect("ended", self, "_on_ended")


func start_npc_dialogue(npc_name):
	if !story_files.has(npc_name):
		push_error("No Ink json: " + npc_name)
		return

	current_npc = npc_name
	story_loaded = false
	pending_knot = ""

	ink_player.destroy()
	ink_player.ink_file = story_files[npc_name]
	ink_player.create_story()


func start_knot(knot_name):
	if ink_player == null:
		push_error("Error：InkPlayer is empty.")
		return

	if ink_player.ink_file == null:
		push_error("Error：No Ink JSON files loaded.")
		return

	if !story_loaded:
		pending_knot = knot_name
		return

	ink_player.set_variable("stolen_time", GlobalState.stolen_time)

	ink_player.choose_path(knot_name)
	continue_story()

	ink_player.choose_path(knot_name)
	continue_story()


func continue_story():
	if !story_loaded:
		return

	var text = ""

	while ink_player.can_continue:
		text += ink_player.continue_story()

	if text != "":
		emit_signal("story_continued", text, ink_player.current_tags)

	if ink_player.has_choices:
		emit_signal("choices_available", ink_player.current_choices)
	else:
		_end_dialogue()


func make_choice(index):
	if !story_loaded:
		return

	ink_player.choose_choice_index(index)
	continue_story()


func get_ink_var(var_name):
	if !story_loaded:
		return null

	return ink_player.get_variable(var_name)


func set_ink_var(var_name, value):
	if !story_loaded:
		return

	ink_player.set_variable(var_name, value)


func _end_dialogue():
	if !story_loaded:
		return

	var ink_val = ink_player.get_variable("stolen_time")

	if ink_val != null:
		GlobalState.stolen_time = int(ink_val)
		GlobalState.emit_signal("time_changed", GlobalState.stolen_time)

	emit_signal("story_ended")


func _on_story_loaded(successfully):
	if !successfully:
		push_error("Ink story load failed: " + current_npc)
		return

	story_loaded = true

	if pending_knot != "":
		var knot = pending_knot
		pending_knot = ""
		start_knot(knot)
func _on_continued(text, tags):
	pass


func _on_ended():
	pass
