extends Control

const INTRO_SCENE := "res://src/scenes/IntroScroll.tscn"

func _process(_delta: float) -> void:
	$AnimationPlayer.play("momo")

func _on_start_pressed() -> void:
	var audio := get_node_or_null("/root/AudioManager")
	if audio and audio.has_node("doorSfx"):
		audio.door_sfx.play()

	get_tree().change_scene_to_file(INTRO_SCENE)

func _on_exit_pressed() -> void:
	var audio := get_node_or_null("/root/AudioManager")
	if audio and audio.has_node("clickSfx"):
		audio.click_sfx.play()

	get_tree().quit()
