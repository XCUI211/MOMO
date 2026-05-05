extends Control

@export var next_scene: String = "res://src/scenes/Battle.tscn"
@export var open_anim: String = "open"
@export var open_anim_time: float = 0
@export var type_speed: float = 0.03
@export var line_pause: float = 0.35
@export var end_pause: float = 2.8

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var text: RichTextLabel = $Scroll/Padding/StoryText

var lines := [
	"Agent X152536 arrives at the edge of a quiet village.",
	"He observes for a moment.",
	"People having pointless conversations,",
	"families moving sluggishly through markets,",
	"an old man feeding birds instead of working.",
	"No sense of urgency.",
	"So inefficient. So unstructured.", 
	"Time is being lost everywhere he looks.",
	"This is exactly where he needs to be.",
	"He adjusts his suit and steps forward.",
	"With the right words, these villagers will gladly give up what they’re wasting anyway.",
	"All it takes is a conversation."
]

var _skipped := false

func _ready() -> void:
	text.text = ""
	anim.play(open_anim)
	_run()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.pressed):
		if not _skipped:
			_skipped = true
			get_tree().change_scene_to_file(next_scene)

func _run() -> void:
	await get_tree().create_timer(open_anim_time).timeout
	if _skipped: return

	text.text = ""
	for line in lines:
		await _type_line(line)
		if _skipped: return
		text.text += "\n"
		await get_tree().create_timer(line_pause).timeout
		if _skipped: return

	await get_tree().create_timer(end_pause).timeout
	if _skipped: return
	get_tree().change_scene_to_file(next_scene)

func _type_line(line: String) -> void:
	for ch in line:
		text.text += ch
		await get_tree().create_timer(type_speed).timeout
		if _skipped: return
