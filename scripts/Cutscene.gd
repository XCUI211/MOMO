extends Node2D

const BATTLE_SCENE := "res://scenes/Battle.tscn"

onready var anim_player : AnimationPlayer = $AnimationPlayer
onready var fade_rect   : ColorRect       = $CanvasLayer/FadeRect

# ------------------------------------------------------------------
func _ready() -> void:
	fade_rect.color = Color(0, 0, 0, 1.0)

	anim_player.connect("animation_finished", self, "_on_animation_finished")

	anim_player.play("fade_in")

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			anim_player.play("play_cutscene")
		"play_cutscene":
			anim_player.play("fade_out")
		"fade_out":
			get_tree().change_scene(BATTLE_SCENE)
