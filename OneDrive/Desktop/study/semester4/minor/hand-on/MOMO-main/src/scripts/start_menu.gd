extends Control

const INTRO_SCENE := "res://src/scenes/IntroScroll.tscn"

func _process(_delta: float) -> void:
	$AnimationPlayer.play("momo")

func _on_start_pressed() -> void:
	AudioManager.door_sfx.play()
	get_tree().change_scene_to_file(INTRO_SCENE)

func _on_exit_pressed() -> void:
	AudioManager.click_sfx.play()
	get_tree().quit()
