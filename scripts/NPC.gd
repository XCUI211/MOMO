extends Area2D


export var npc_id       : String = ""      
export var ink_knot_name: String = "" 

signal npc_clicked(npc_id, knot_name)    

onready var interact_hint: Node = $InteractHint   

var _hovered: bool = false

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited",  self, "_on_mouse_exited")
	connect("input_event",   self, "_on_input_event")

	if GlobalState.npc_talked[npc_id]:
		_set_talked_visual()

	if interact_hint:
		interact_hint.visible = false

func _on_mouse_entered() -> void:
	_hovered = true
	if interact_hint and not GlobalState.npc_talked[npc_id]:
		interact_hint.visible = true

func _on_mouse_exited() -> void:
	_hovered = false
	if interact_hint:
		interact_hint.visible = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if GlobalState.npc_talked[npc_id]:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("npc_clicked", npc_id, ink_knot_name)

func _set_talked_visual() -> void:
	if has_node("Sprite"):
		$Sprite.modulate = Color(0.55, 0.55, 0.55, 1.0)
	if interact_hint:
		interact_hint.visible = false
