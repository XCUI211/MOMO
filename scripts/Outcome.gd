extends Node2D


const MAIN_SCENE := "res://scenes/MainScene.tscn"

const OUTCOMES := {
	"defeat": {
		"title":      "Defeat",
		"body":       "You have fallen, and everything fades into silence.\nPerhaps this was fate all along.",
		"bg_texture": "res://assets/outcomes/bg_defeat.png",
	},
	"win_a": {
		"title":      "Pyrrhic Victory — Scarred",
		"body":       "You survived, but at a heavy cost.\nYour stats fell short, and victory feels bitter.",
		"bg_texture": "res://assets/outcomes/bg_win_a.png",
	},
	"win_b": {
		"title":      "Victory — The Journey Home",
		"body":       "With proper preparation, you claimed victory.\nThe road ahead is long, but you have proven yourself.",
		"bg_texture": "res://assets/outcomes/bg_win_b.png",
	},
	"win_c": {
		"title":      "Perfect Victory — Hero",
		"body":       "With the highest preparation, you achieved the best ending.\nYour name will be remembered forever.",
		"bg_texture": "res://assets/outcomes/bg_win_c.png",
	},
}

const THRESHOLD_LOW  := 30
const THRESHOLD_HIGH := 70

onready var bg_rect        : TextureRect   = $CanvasLayer/BackgroundRect
onready var title_label    : Label         = $CanvasLayer/TitleLabel
onready var body_label     : RichTextLabel = $CanvasLayer/BodyLabel
onready var restart_button : Button        = $CanvasLayer/RestartButton

# ------------------------------------------------------------------


func _ready() -> void:
	print("bg_rect = ", bg_rect)
	print("title_label = ", title_label)
	print("body_label = ", body_label)
	print("restart_button = ", restart_button)
	print("Outcome ready")
	print("player_value = ", GlobalState.stolen_time)
	print("battle_won = ", GlobalState.battle_won)
	restart_button.connect("pressed", self, "_on_restart_pressed")

	var outcome_key := _determine_outcome()
	_display_outcome(outcome_key)

	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("fade_in")

func _determine_outcome() -> String:
	if not GlobalState.battle_won:
		return "defeat"

	var v := GlobalState.stolen_time
	if v < THRESHOLD_LOW:
		return "win_a"
	elif v < THRESHOLD_HIGH:
		return "win_b"
	else:
		return "win_c"
func _display_outcome(key: String) -> void:
	var data: Dictionary = OUTCOMES[key]

	title_label.text = data["title"]
	
	body_label.bbcode_text = "[center]" + data["body"] + "[/center]"

	var tex = load(data["bg_texture"])
	if tex:
		bg_rect.texture = tex
	else:
		push_warning("[Outcome] No picture: " + data["bg_texture"])
		
	print(title_label.text)
	print(body_label.text)
func _on_restart_pressed() -> void:
	GlobalState.reset()
	get_tree().change_scene(MAIN_SCENE)
