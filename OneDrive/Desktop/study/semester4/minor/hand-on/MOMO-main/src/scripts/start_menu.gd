extends Control

const INTRO_SCENE := "res://src/scenes/IntroScroll.tscn"

func _ready() -> void:
	reset_bgm_to_menu()

func _process(_delta: float) -> void:
	$AnimationPlayer.play("momo")

func reset_bgm_to_menu() -> void:
	var audio := get_node_or_null("/root/AudioManager")
	if audio == null:
		return

	for child in audio.get_children():
		if child.has_method("stop"):
			child.stop()

	if audio.has_node("BGM"):
		audio.get_node("BGM").play()

func _on_start_pressed() -> void:
	AudioManager.door_sfx.play()
	get_tree().change_scene_to_file(INTRO_SCENE)

func _on_exit_pressed() -> void:
	AudioManager.click_sfx.play()
	get_tree().quit()
