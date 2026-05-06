extends Node

signal story_continued(text: String, tags: Array)
signal choices_available(choices: Array)
signal story_ended

var ink_player = null
var current_npc := ""
var story_loaded := false
var pending_knot := ""
var story_files: Dictionary = {
	"npc_a": preload("res://ink_story/beppo.ink.json"),
	"npc_b": preload("res://ink_story/Nino.ink.json"),
	"npc_c": preload("res://ink_story/baker.ink.json"),
	"npc_d": preload("res://ink_story/barber.ink.json"),
}

func _ready() -> void:
	ink_player = InkPlayer.new()
	add_child(ink_player)
	ink_player.loads_in_background = false
	ink_player.loaded.connect(_on_story_loaded)
	ink_player.continued.connect(_on_continued)
	ink_player.ended.connect(_on_ended)

func start_npc_dialogue(npc_name: String) -> void:
	if not story_files.has(npc_name):
		push_error("No Ink json: " + npc_name)
		return

	current_npc = npc_name
	story_loaded = false
	pending_knot = ""
	ink_player.destroy()
	ink_player.ink_file = story_files[npc_name]
	ink_player.create_story()

func start_knot(knot_name: String) -> void:
	if ink_player == null:
		push_error("Error: InkPlayer is empty.")
		return
	if ink_player.ink_file == null:
		push_error("Error: No Ink JSON files loaded.")
		return
	if not story_loaded:
		pending_knot = knot_name
		return

	ink_player.set_variable("stolen_time", GlobalState.stolen_time)
	ink_player.choose_path(knot_name)
	continue_story()

func continue_story() -> void:
	if not story_loaded:
		return

	var text := ""
	while ink_player.can_continue:
		text += ink_player.continue_story()

	if not text.is_empty():
		story_continued.emit(text, ink_player.current_tags)

	if ink_player.has_choices:
		choices_available.emit(ink_player.current_choices)
	else:
		_end_dialogue()

func make_choice(index: int) -> void:
	if not story_loaded:
		return
	ink_player.choose_choice_index(index)
	continue_story()

func get_ink_var(var_name: String) -> Variant:
	if not story_loaded:
		return null
	return ink_player.get_variable(var_name)

func set_ink_var(var_name: String, value: Variant) -> void:
	if not story_loaded:
		return
	ink_player.set_variable(var_name, value)

func _end_dialogue() -> void:
	if not story_loaded:
		return

	var ink_val: Variant = ink_player.get_variable("stolen_time")
	if ink_val != null:
		GlobalState.stolen_time = int(ink_val)
		GlobalState.value_changed.emit(GlobalState.stolen_time)

	story_ended.emit()

func _on_story_loaded(successfully: bool) -> void:
	if not successfully:
		push_error("Ink story load failed: " + current_npc)
		return

	story_loaded = true
	if not pending_knot.is_empty():
		var knot := pending_knot
		pending_knot = ""
		start_knot(knot)

func _on_continued(_text: String, _tags: Array) -> void:
	pass

func _on_ended() -> void:
	pass
