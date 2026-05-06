extends Node2D

const MAIN_SCENE := "res://scenes/MainScene.tscn"
const OUTCOME_FONT := preload("res://fonts/NESCyrillic.ttf")

const THRESHOLD_LOW := 30
const THRESHOLD_HIGH := 70

const TYPE_SPEED := 0.035

const TEXT_COLOR := Color("#D9D9D9")
const OUTLINE_COLOR := Color("#000000")
const OUTLINE_SIZE := 4

const OUTCOMES := {
	"defeat": {
		"title": "Defeat",
		"body": "You lost! Momo ruined your big plans. \n No worries though, we’ll just have another agent replace you. ",
		"bg_texture": "res://assets/outcomes/bg_defeat.png",
	},
	"win_a": {
		"title": "Pyrrhic Victory — Scarred",
		"body": "You survived, but at a heavy cost.\nYour stats fell short, and victory feels bitter.",
		"bg_texture": "res://assets/outcomes/bg_win_a.png",
	},
	"win_b": {
		"title": "Victory — The Journey Home",
		"body": "With proper preparation, you claimed victory.\nThe road ahead is long, but you have proven how much you are good at manipulate time.",
		"bg_texture": "res://assets/outcomes/bg_win_b.png",
	},
	"win_c": {
		"title": "Perfect Victory — Hero",
		"body": "You won! \n This village is now a capitalistic hellscape, I hope you feel good very about yourself…",
		"bg_texture": "res://assets/outcomes/bg_win_c.png",
	},
}

@onready var bg_rect: TextureRect = $CanvasLayer/BackgroundRect
@onready var title_label: Label = $CanvasLayer/TitleLabel
@onready var body_label: RichTextLabel = $CanvasLayer/BodyLabel
@onready var restart_button: Button = $CanvasLayer/RestartButton

var current_body_text := ""
var is_typing := false

func _ready() -> void:
	_apply_fonts()

	restart_button.pressed.connect(_on_restart_pressed)

	var outcome_key := _determine_outcome()
	_display_outcome(outcome_key)

	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("fade_in")
		
func play_outcome_bgm(key: String) -> void:
	var audio := get_node_or_null("/root/AudioManager")
	if audio == null:
		return

	for child in audio.get_children():
		if child.has_method("stop"):
			child.stop()

	if key == "defeat":
		var defeat_bgm = audio.get_node_or_null("defeatBgm")
		if defeat_bgm:
			defeat_bgm.play()
	else:
		var victory_bgm = audio.get_node_or_null("victoryBgm")
		if victory_bgm:
			victory_bgm.play()
			
func _apply_fonts() -> void:
	title_label.add_theme_font_override("font", OUTCOME_FONT)
	title_label.add_theme_font_size_override("font_size", 63)
	title_label.add_theme_color_override("font_color", TEXT_COLOR)
	title_label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	title_label.add_theme_constant_override("outline_size", OUTLINE_SIZE)

	body_label.add_theme_font_override("normal_font", OUTCOME_FONT)
	body_label.add_theme_font_size_override("normal_font_size", 36)
	body_label.add_theme_color_override("default_color", TEXT_COLOR)
	body_label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	body_label.add_theme_constant_override("outline_size", OUTLINE_SIZE)

	restart_button.add_theme_font_override("font", OUTCOME_FONT)
	restart_button.add_theme_font_size_override("font_size", 33)
	restart_button.add_theme_color_override("font_color", TEXT_COLOR)
	restart_button.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	restart_button.add_theme_constant_override("outline_size", OUTLINE_SIZE)

func _determine_outcome() -> String:
	if not GlobalState.battle_won:
		return "defeat"

	var v: int = GlobalState.stolen_time
	if v < THRESHOLD_LOW:
		return "win_a"
	elif v < THRESHOLD_HIGH:
		return "win_b"
	return "win_c"

func _display_outcome(key: String) -> void:
	play_outcome_bgm(key)
	var data: Dictionary = OUTCOMES[key]

	title_label.text = data["title"]
	current_body_text = data["body"]

	body_label.text = ""

	var tex := load(data["bg_texture"])
	if tex is Texture2D:
		bg_rect.texture = tex as Texture2D
	else:
		push_warning("[Outcome] No picture: " + str(data["bg_texture"]))

	start_body_typing()

func start_body_typing() -> void:
	is_typing = true
	body_label.text = ""

	var typed_text := ""

	for i in current_body_text.length():
		if not is_typing:
			break

		typed_text += current_body_text[i]
		body_label.text = "[center]%s[/center]" % typed_text
		await get_tree().create_timer(TYPE_SPEED).timeout

	finish_typing()

func finish_typing() -> void:
	is_typing = false
	body_label.text = "[center]%s[/center]" % current_body_text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton and event.pressed:
		if is_typing:
			finish_typing()

func _on_restart_pressed() -> void:
	GlobalState.reset()
	get_tree().change_scene_to_file(MAIN_SCENE)
