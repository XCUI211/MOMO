extends Node2D

const BATTLE_SCENE := "res://src/scenes/Battle.tscn"

@onready var dialogue_box = $CanvasLayer/DialogueBox

var boss_dialogue := [
	{"name": "Momo", "text": "You finally came."},
	{"name": "Momo", "text": "All the stolen time led you here."},
	{"name": "Momo", "text": "I will protect the people I love and our precious time. I will defeat you."}
]


func _ready() -> void:
	if has_node("CanvasLayer/FadeRect"):
		$CanvasLayer/FadeRect.hide()

	dialogue_box.cutscene_dialogue_finished.connect(_on_cutscene_dialogue_finished)
	dialogue_box.play_cutscene_dialogue(boss_dialogue, "default")


func _on_cutscene_dialogue_finished() -> void:
	get_tree().change_scene_to_file(BATTLE_SCENE)
