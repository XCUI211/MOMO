extends Node

@export var music_enabled: bool = true
@export var sfx_enabled: bool = true

# ===== SFX =====
@onready var click_sfx: AudioStreamPlayer = $clickSfx
@onready var door_sfx: AudioStreamPlayer = $doorSfx

# ===== BGM=====
@onready var bgm: AudioStreamPlayer2D = $BGM

func _ready() -> void:
	bgm.play()

	
	
