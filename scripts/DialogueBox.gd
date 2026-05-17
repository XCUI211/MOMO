extends Control

signal dialogue_closed(npc_id: String)
signal system_prompt_clicked
signal cutscene_dialogue_finished

const CHAR_DELAY := 0.01
const TEXT_PAGE_HEIGHT_MARGIN := 8.0
const PAGE_BREAK_CHARS := " \n\t，。！？、；：,.!?;:"
const PORTRAIT_FLOAT_DISTANCE := 6.0
const PORTRAIT_FLOAT_TIME := 0.45

const NPC_BACKGROUNDS := {
	"npc_a": "res://materials/IMG_2992.png",
	"npc_b": "res://materials/IMG_2993.png",
	"npc_c": "res://materials/IMG_2999.png",
	"npc_d": "res://materials/IMG_2994.png",
}

const NPC_PORTRAITS := {
	"npc_a": "res://materials/IMG_2947.png",
	"npc_b": "res://materials/IMG_2948.png",
	"npc_c": "res://materials/IMG_2949.png",
	"npc_d": "res://materials/IMG_2950.png",
}

const NPC_NAMES := {
	"npc_a": "Bepoo",
	"npc_b": "Nino",
	"npc_c": "Fusi",
	"npc_d": "Figaro",
}

const THEMES := {
	"default": {
		"panel_bg":        Color(0.11, 0.10, 0.09, 0.72),
		"panel_border":    Color("#4a4540"),
		"border_width":    2,
		"corner_radius":   6,
		"top_accent":      Color(0, 0, 0, 0),
		"name_bg":         Color("#2e2a26"),
		"name_color":      Color("#c8bfb0"),
		"name_border":     Color("#5a5248"),
		"text_color":      Color("#b0a898"),
		"hint_color":      Color("#6a6258"),
		"btn_bg":          Color("#252220"),
		"btn_border":      Color("#5a5248"),
		"btn_text":        Color("#a8a098"),
		"btn_hover_bg":    Color("#3a3530"),
		"btn_radius":      4,
		"hint_text_normal": "▶",
		"hint_text_close": "[ Click to continue ]",
	},

	"npc_a": {
		"panel_bg":        Color("#f0ece4"),
		"panel_border":    Color("#c8b898"),
		"border_width":    2,
		"corner_radius":   4,
		"top_accent":      Color("#8a7a60"),
		"name_bg":         Color("#8a7a60"),
		"name_color":      Color("#f5efe0"),
		"name_border":     Color("#6a5a40"),
		"text_color":      Color("#4a3e2e"),
		"hint_color":      Color("#a89878"),
		"btn_bg":          Color("#faf6ee"),
		"btn_border":      Color("#c8b898"),
		"btn_text":        Color("#6a5a3a"),
		"btn_hover_bg":    Color("#ede8dc"),
		"btn_radius":      2,
		"hint_text_normal": "▶ Click to continue",
		"hint_text_close": "▶ Leave the street",
	},

	"npc_b": {
		"panel_bg":        Color("#1a1208"),
		"panel_border":    Color("#6a4a18"),
		"border_width":    2,
		"corner_radius":   6,
		"top_accent":      Color("#c88a30"),
		"name_bg":         Color(0, 0, 0, 0),
		"name_color":      Color("#c8982a"),
		"name_border":     Color("#6a4a18"),
		"text_color":      Color("#c8b070"),
		"hint_color":      Color("#6a4a18"),
		"btn_bg":          Color("#251808"),
		"btn_border":      Color("#6a4a18"),
		"btn_text":        Color("#c8982a"),
		"btn_hover_bg":    Color("#3a2810"),
		"btn_radius":      2,
		"hint_text_normal": "▶ Click to continue",
		"hint_text_close": "▶ Leave the bar",
	},

	"npc_c": {
		"panel_bg":        Color("#fdf8f0"),
		"panel_border":    Color("#e8c878"),
		"border_width":    2,
		"corner_radius":   12,
		"top_accent":      Color(0, 0, 0, 0),
		"name_bg":         Color("#f5d888"),
		"name_color":      Color("#7a5a20"),
		"name_border":     Color("#e8b848"),
		"text_color":      Color("#6a4e28"),
		"hint_color":      Color("#c8a840"),
		"btn_bg":          Color("#fffbf0"),
		"btn_border":      Color("#e8c878"),
		"btn_text":        Color("#8a6a28"),
		"btn_hover_bg":    Color("#fdf0d0"),
		"btn_radius":      20,
		"hint_text_normal": "▶ Click to continue",
		"hint_text_close": "▶ Leave the bakery",
	},

	"npc_d": {
		"panel_bg":        Color("#f8f8f8"),
		"panel_border":    Color("#3060c8"),
		"border_width":    2,
		"corner_radius":   6,
		"top_accent":      Color("#c83030"),
		"name_bg":         Color("#e8eef8"),
		"name_color":      Color("#2040a0"),
		"name_border":     Color("#3060c8"),
		"text_color":      Color("#2a2a2a"),
		"hint_color":      Color("#3060c8"),
		"btn_bg":          Color("#f0f4fc"),
		"btn_border":      Color("#3060c8"),
		"btn_text":        Color("#2040a0"),
		"btn_hover_bg":    Color("#dce8f8"),
		"btn_radius":      4,
		"hint_text_normal": "▶ Click to continue",
		"hint_text_close": "▶ Leave the Barber Shop",
	},
}

@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/NameLabel
@onready var text_label: RichTextLabel = $Panel/TextLabel
@onready var continue_hint: Label = $Panel/ContinueHint
@onready var choices_container: VBoxContainer = $ChoicesContainer
@onready var dialogue_bg: TextureRect = $DialogueBackground
@onready var portrait: TextureRect = $CharacterPortrait
@onready var top_accent_bar: ColorRect = $Panel/TopAccentBar if has_node("Panel/TopAccentBar") else null

var _current_npc_id := ""
var _waiting_choice := false
var _text_animating := false
var _pending_choices: Array = []
var _story_ended := false
var _current_theme: Dictionary = {}

var _current_full_text := ""
var _typewriter_skip_requested := false

var _dialogue_pages: Array = []
var _dialogue_page_index := 0

enum Mode { NORMAL, SYSTEM_PROMPT, CUTSCENE }
var _current_mode: Mode = Mode.NORMAL
var _system_prompt_click_to_continue := false

var _cutscene_lines: Array = []
var _cutscene_line_index := 0

var _portrait_base_position := Vector2.ZERO
var _portrait_float_tween: Tween


func _ready() -> void:
	visible = false
	_portrait_base_position = portrait.position

	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.fit_content = false
	text_label.scroll_active = false
	text_label.scroll_following = false

	InkManager.story_continued.connect(_on_story_continued)
	InkManager.choices_available.connect(_on_choices_available)
	InkManager.story_ended.connect(_on_story_ended)


func _reset_state_and_ui(mode: Mode, theme_key: String = "default") -> void:
	_current_mode = mode
	_current_npc_id = ""
	_waiting_choice = false
	_story_ended = false
	_text_animating = false
	_typewriter_skip_requested = false
	_current_full_text = ""
	_pending_choices.clear()
	_dialogue_pages.clear()
	_dialogue_page_index = 0
	_stop_portrait_speaking(false)
	
	_clear_choices()
	_apply_theme(theme_key)
	
	continue_hint.visible = false
	dialogue_bg.visible = false
	dialogue_bg.texture = null
	portrait.visible = false
	name_label.visible = false
	choices_container.visible = false
	
	visible = true


func _apply_theme(theme_key: String) -> void:
	var t: Dictionary = THEMES[theme_key]

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = t["panel_bg"]
	panel_style.border_color = t["panel_border"]
	panel_style.set_border_width_all(t["border_width"])
	panel_style.set_corner_radius_all(t["corner_radius"])
	panel_style.anti_aliasing = true
	panel.add_theme_stylebox_override("panel", panel_style)

	var accent_color: Color = t["top_accent"]
	var has_accent: bool = accent_color.a > 0.01

	if top_accent_bar != null:
		top_accent_bar.visible = has_accent
		top_accent_bar.color = accent_color
	else:
		if has_accent:
			panel_style.border_color = accent_color
			panel_style.set_border_width(SIDE_TOP, 4)
			panel_style.border_blend = false

	var name_style := StyleBoxFlat.new()
	name_style.bg_color = t["name_bg"]
	name_style.border_color = t["name_border"]
	name_style.set_border_width_all(1)
	name_style.set_corner_radius_all(t["btn_radius"])
	name_style.content_margin_left = 12
	name_style.content_margin_right = 12
	name_style.content_margin_top = 3
	name_style.content_margin_bottom = 3

	name_label.add_theme_stylebox_override("normal", name_style)
	name_label.add_theme_color_override("font_color", t["name_color"])

	text_label.add_theme_color_override("default_color", t["text_color"])
	continue_hint.add_theme_color_override("font_color", t["hint_color"])

	_current_theme = t


func _is_confirm_action(event: InputEvent) -> bool:
	var clicked = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	var confirmed = event is InputEventKey and (event.keycode == KEY_SPACE or event.keycode == KEY_ENTER) and event.pressed
	return clicked or confirmed


func _start_portrait_speaking() -> void:
	if _current_mode != Mode.NORMAL or not portrait.visible or portrait.texture == null:
		return

	_stop_portrait_speaking(false)
	portrait.position = _portrait_base_position
	_portrait_float_tween = create_tween().set_loops()
	_portrait_float_tween.tween_property(
		portrait,
		"position:y",
		_portrait_base_position.y - PORTRAIT_FLOAT_DISTANCE,
		PORTRAIT_FLOAT_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_portrait_float_tween.tween_property(
		portrait,
		"position:y",
		_portrait_base_position.y,
		PORTRAIT_FLOAT_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _stop_portrait_speaking(animate_back: bool = true) -> void:
	if _portrait_float_tween != null and _portrait_float_tween.is_valid():
		_portrait_float_tween.kill()
	_portrait_float_tween = null

	if portrait == null:
		return

	if animate_back and portrait.visible:
		var reset_tween := create_tween()
		reset_tween.tween_property(
			portrait,
			"position",
			_portrait_base_position,
			0.12
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		portrait.position = _portrait_base_position




func _input(event: InputEvent) -> void:
	if not visible or not _is_confirm_action(event):
		return

	if _current_mode == Mode.SYSTEM_PROMPT:
		if _system_prompt_click_to_continue:
			get_viewport().set_input_as_handled()
			system_prompt_clicked.emit()
		return

	if _text_animating:
		get_viewport().set_input_as_handled()
		_finish_typewriter_now()
		return

	if _has_more_dialogue_pages():
		get_viewport().set_input_as_handled()
		_show_next_dialogue_page()
		return

	if _waiting_choice:
		if event is InputEventMouseButton:
			var click_pos: Vector2 = event.position
			var container_rect := choices_container.get_global_rect()
			if choices_container.visible and container_rect.has_point(click_pos):
				return 
		get_viewport().set_input_as_handled()
		return

	get_viewport().set_input_as_handled()

	if _current_mode == Mode.CUTSCENE:
		_show_next_cutscene_line()
		return

	if _story_ended:
		_close()
		return

	InkManager.continue_story()

func _finish_typewriter_now() -> void:
	if not _text_animating:
		return

	_typewriter_skip_requested = true
	_text_animating = false
	text_label.text = _current_full_text
	_stop_portrait_speaking(false)


func _on_story_continued(text: String, _tags: Array) -> void:
	_waiting_choice = false
	_story_ended = false
	_pending_choices = []
	_clear_choices()
	continue_hint.visible = false

	_dialogue_pages = _split_text_to_pages(text.strip_edges())
	_dialogue_page_index = 0

	if _dialogue_pages.is_empty():
		_dialogue_pages.append("")

	_play_typewriter(_dialogue_pages[_dialogue_page_index])


func _on_choices_available(choices: Array) -> void:
	_waiting_choice = true
	continue_hint.visible = false

	if _text_animating:
		_pending_choices = choices
	else:
		_show_choices(choices)


func _on_story_ended() -> void:
	_story_ended = true


func _play_typewriter(full_text: String) -> void:
	_text_animating = true
	_typewriter_skip_requested = false
	_current_full_text = full_text
	text_label.text = ""
	_start_portrait_speaking()

	for i in range(full_text.length() + 1):
		if not is_inside_tree():
			_text_animating = false
			_stop_portrait_speaking(false)
			return

		if _typewriter_skip_requested:
			text_label.text = full_text
			break

		if not _text_animating:
			text_label.text = full_text
			break

		text_label.text = full_text.substr(0, i)
		await get_tree().create_timer(CHAR_DELAY).timeout

	_text_animating = false
	_typewriter_skip_requested = false
	_stop_portrait_speaking()

	if not is_inside_tree():
		return

	text_label.text = full_text
	_after_typewriter()


func _after_typewriter() -> void:
	if _has_more_dialogue_pages():
		var page_text: String = _current_theme.get("hint_text_normal", "▼")
		continue_hint.text = page_text
		continue_hint.visible = true
		return

	if _current_mode == Mode.CUTSCENE:
		var cutscene_hint: String = _current_theme.get("hint_text_normal", "▶")
		continue_hint.text = cutscene_hint
		continue_hint.visible = true
		return

	if _pending_choices.size() > 0:
		_show_choices(_pending_choices)
		_pending_choices = []
	elif _story_ended:
		var close_text: String = _current_theme.get("hint_text_close", "[ Click to continue ]")
		continue_hint.text = close_text
		continue_hint.visible = true
	elif not _waiting_choice:
		var normal_text: String = _current_theme.get("hint_text_normal", "▼")
		continue_hint.text = normal_text
		continue_hint.visible = true


func _has_more_dialogue_pages() -> bool:
	return _dialogue_page_index < _dialogue_pages.size() - 1


func _show_next_dialogue_page() -> void:
	if not _has_more_dialogue_pages():
		return

	_dialogue_page_index += 1
	continue_hint.visible = false
	_play_typewriter(_dialogue_pages[_dialogue_page_index])


func _split_text_to_pages(full_text: String) -> Array:
	var pages: Array = []
	var source := full_text.strip_edges()

	if source.is_empty():
		return pages

	var pos := 0
	var guard := 0

	while pos < source.length() and guard < 200:
		guard += 1

		var low := pos + 1
		var high := source.length()
		var best := low

		while low <= high:
			var mid := int((low + high) / 2)
			var candidate := source.substr(pos, mid - pos).strip_edges()

			if _text_fits_in_box(candidate):
				best = mid
				low = mid + 1
			else:
				high = mid - 1

		if best < source.length():
			best = _find_safe_page_break(source, pos, best)

		var page := source.substr(pos, best - pos).strip_edges()

		if page.is_empty():
			page = source.substr(pos, 1)
			best = pos + 1

		pages.append(page)

		pos = best
		while pos < source.length():
			var ch := source.substr(pos, 1)
			if ch == " " or ch == "\n" or ch == "\t":
				pos += 1
			else:
				break

	if pages.is_empty():
		pages.append(source)

	return pages


func _text_fits_in_box(candidate: String) -> bool:
	if candidate.is_empty():
		return true

	var font: Font = text_label.get_theme_font("normal_font")
	var font_size: int = text_label.get_theme_font_size("normal_font_size")

	var max_width := float(text_label.size.x)
	var max_height := float(text_label.size.y) - TEXT_PAGE_HEIGHT_MARGIN

	if max_width <= 1.0:
		max_width = 850.0
	if max_height <= 1.0:
		max_height = 90.0

	var break_flags := TextServer.BREAK_MANDATORY | TextServer.BREAK_WORD_BOUND | TextServer.BREAK_ADAPTIVE

	var measured_size := font.get_multiline_string_size(
		candidate,
		HORIZONTAL_ALIGNMENT_LEFT,
		max_width,
		font_size,
		-1,
		break_flags
	)

	return measured_size.y <= max_height


func _find_safe_page_break(source: String, start: int, max_end: int) -> int:
	var page_len := max_end - start
	var min_end := start + int(float(page_len) * 0.6)

	for i in range(max_end, min_end, -1):
		var ch := source.substr(i - 1, 1)
		if PAGE_BREAK_CHARS.find(ch) != -1:
			return i

	return max_end


func _show_choices(choices: Array) -> void:
	_clear_choices()
	choices_container.visible = true

	for i in range(choices.size()):
		var btn := Button.new()
		btn.text = choices[i].text

		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
		btn.clip_text = false
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 44)
		btn.alignment = HORIZONTAL_ALIGNMENT_CENTER

		btn.pressed.connect(_on_choice_pressed.bind(i))
		_style_choice_button(btn)
		choices_container.add_child(btn)


func _style_choice_button(btn: Button) -> void:
	if _current_theme.is_empty():
		return

	var t := _current_theme

	var s_normal := StyleBoxFlat.new()
	s_normal.bg_color = t["btn_bg"]
	s_normal.border_color = t["btn_border"]
	s_normal.set_border_width_all(1)
	s_normal.set_corner_radius_all(t["btn_radius"])
	s_normal.content_margin_left = 12
	s_normal.content_margin_right = 12
	s_normal.content_margin_top = 8
	s_normal.content_margin_bottom = 8

	var s_hover := s_normal.duplicate() as StyleBoxFlat
	s_hover.bg_color = t["btn_hover_bg"]

	var s_pressed := s_normal.duplicate() as StyleBoxFlat
	s_pressed.bg_color = t["btn_hover_bg"].darkened(0.1)

	btn.add_theme_stylebox_override("normal", s_normal)
	btn.add_theme_stylebox_override("hover", s_hover)
	btn.add_theme_stylebox_override("pressed", s_pressed)

	btn.add_theme_color_override("font_color", t["btn_text"])
	btn.add_theme_color_override("font_hover_color", t["btn_text"])
	btn.add_theme_color_override("font_pressed_color", t["btn_text"].darkened(0.15))
	btn.add_theme_color_override("font_focus_color", t["btn_text"])


func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()


func _on_choice_pressed(index: int) -> void:
	print("choice pressed: ", index)
	_clear_choices()
	_waiting_choice = false
	_dialogue_pages = []
	_dialogue_page_index = 0
	InkManager.make_choice(index)


func open_dialogue(npc_id: String, knot_name: String) -> void:
	var theme_key = npc_id if THEMES.has(npc_id) else "default"
	_reset_state_and_ui(Mode.NORMAL, theme_key)
	
	_current_npc_id = npc_id
	name_label.text = NPC_NAMES.get(npc_id, npc_id)
	name_label.visible = true
	text_label.text = ""
	choices_container.visible = true
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var bg_path: String = NPC_BACKGROUNDS.get(npc_id, "")
	if not bg_path.is_empty():
		dialogue_bg.visible = true
		dialogue_bg.texture = load(bg_path)
		dialogue_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		dialogue_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	var portrait_path: String = NPC_PORTRAITS.get(npc_id, "")
	if not portrait_path.is_empty():
		portrait.visible = true
		portrait.texture = load(portrait_path)
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		_portrait_base_position = portrait.position

	InkManager.start_npc_dialogue(npc_id)
	InkManager.start_knot(knot_name)


func show_system_prompt(prompt_text: String, click_to_continue: bool = false) -> void:
	_reset_state_and_ui(Mode.SYSTEM_PROMPT, "default")
	_system_prompt_click_to_continue = click_to_continue
	_current_full_text = prompt_text
	text_label.text = prompt_text
	
	continue_hint.visible = click_to_continue
	if click_to_continue:
		continue_hint.text = _current_theme.get("hint_text_normal", "▶ Click to continue")
		mouse_filter = Control.MOUSE_FILTER_STOP
		panel.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE


func hide_system_prompt() -> void:
	if _current_mode == Mode.SYSTEM_PROMPT:
		_stop_portrait_speaking(false)
		visible = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.mouse_filter = Control.MOUSE_FILTER_IGNORE


func play_cutscene_dialogue(lines: Array, theme_key: String = "default") -> void:
	_reset_state_and_ui(Mode.CUTSCENE, theme_key)
	_cutscene_lines = lines
	_cutscene_line_index = 0
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	name_label.visible = true

	_show_next_cutscene_line()


func _show_next_cutscene_line() -> void:
	if _cutscene_line_index >= _cutscene_lines.size():
		_current_mode = Mode.NORMAL
		visible = false
		cutscene_dialogue_finished.emit()
		return

	var line: Dictionary = _cutscene_lines[_cutscene_line_index]
	_cutscene_line_index += 1

	name_label.text = str(line.get("name", ""))
	continue_hint.visible = false

	var line_text := str(line.get("text", "")).strip_edges()

	_dialogue_pages = _split_text_to_pages(line_text)
	_dialogue_page_index = 0

	if _dialogue_pages.is_empty():
		_dialogue_pages.append("")

	_play_typewriter(_dialogue_pages[_dialogue_page_index])


func _close() -> void:
	_stop_portrait_speaking()
	var closed_npc_id := _current_npc_id
	_reset_state_and_ui(Mode.NORMAL)
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dialogue_closed.emit(closed_npc_id)
