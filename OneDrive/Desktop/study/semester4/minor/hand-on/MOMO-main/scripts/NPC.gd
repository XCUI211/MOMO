extends Area2D

signal npc_clicked(npc_id: String, knot_name: String)

@export var npc_id := ""
@export var ink_knot_name := ""

@onready var interact_hint: Node = $InteractHint

var _hovered := false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

	if GlobalState.npc_talked.get(npc_id, false):
		_set_talked_visual()

	if interact_hint:
		interact_hint.visible = false

func _on_mouse_entered() -> void:
	_hovered = true
	if interact_hint and not GlobalState.npc_talked.get(npc_id, false):
		interact_hint.visible = true

func _on_mouse_exited() -> void:
	_hovered = false
	if interact_hint:
		interact_hint.visible = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if GlobalState.npc_talked.get(npc_id, false):
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		npc_clicked.emit(npc_id, ink_knot_name)

func _set_talked_visual() -> void:
	if has_node("Sprite2D"):
		$Sprite2D.modulate = Color(0.55, 0.55, 0.55, 1.0)
	if interact_hint:
		interact_hint.visible = false
