extends Control

signal textbox_closed

const OUTCOME_SCENE := "res://scenes/Outcome.tscn"

const MOMO_HEALTH := 100
const MOMO_MIN_DAMAGE := 10
const MOMO_MAX_DAMAGE := 40

const PLAYER_MAX_HEALTH := 100
const GREYMEN_DAMAGE := 20

var current_player_health = 0
var current_player_time = 0
var current_momo_health = 0
var current_momo_damage = 0
var is_defending = false
var is_isolating = false

var attack_time = 10
var defend_time = 5
var isolate_time = 10

func _ready():
	AudioManager.bgm.stop()
	AudioManager.battle.play()
	current_player_health = PLAYER_MAX_HEALTH
	current_player_time = GlobalState.stolen_time
	current_momo_health = MOMO_HEALTH

	set_health($MomoContainer/ProgressBar, current_momo_health, MOMO_HEALTH)
	set_time($PlayerPanel/PlayerData/TimeBar, current_player_time, GlobalState.stolen_time)
	set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PLAYER_MAX_HEALTH)

	$Textbox.hide()
	$ActionsPanel.hide()
	$Actionbox.hide()

	display_text("Momo appears! Defeat her with your stolen time!")
	await self.textbox_closed

	greymen_turn()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func set_time(progress_bar, current_time, max_time):
	progress_bar.value = current_time
	progress_bar.max_value = max_time
	progress_bar.get_node("Label").text = "Time: %d/%d" % [current_time, max_time]

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func go_to_outcome(player_won: bool):
	GlobalState.stolen_time = current_player_time
	GlobalState.battle_won = player_won
	get_tree().change_scene_to_file(OUTCOME_SCENE)

func momo_win(text):
	display_text(text)
	await self.textbox_closed
	go_to_outcome(false)

func greymen_win(text):
	display_text(text)
	await self.textbox_closed
	go_to_outcome(true)

func greymen_turn():
	var turn_prompts = [
		"Your time is running thin! Take the initiative!",
		"The stage is yours. What's the plan?",
		"Momo's waiting... strike now!",
		"Back to you! Don't hold back!",
		"No time to waste! Make your move!"
	]

	current_momo_damage = randi_range(MOMO_MIN_DAMAGE, MOMO_MAX_DAMAGE)

	display_text("Momo is going to give %d damage to you next round!" % current_momo_damage)
	await self.textbox_closed
	
	$MomoContainer/Damage.text = "Damage: %d" %current_momo_damage
	var tween = create_tween()
	tween.tween_property($MomoContainer/Damage, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property($MomoContainer/Damage, "scale", Vector2(1.0, 1.0), 0.2)

	display_text(turn_prompts.pick_random())
	await self.textbox_closed

	$ActionsPanel.show()

func momo_turn():
	display_text("Momo launches at you fiercely!")
	await self.textbox_closed

	if is_defending:
		display_text("You recruit a greymen successfully!")
		await self.textbox_closed

		is_defending = false
		var defend_damage = randi_range(0, current_momo_damage)

		current_player_health = max(0, current_player_health - defend_damage)

		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished

		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PLAYER_MAX_HEALTH)

		display_text("WHAM! The new greymen bears %d damage for you, so you only got %d damage!" % [current_momo_damage - defend_damage, defend_damage])
		await self.textbox_closed

		if current_player_health > 0:
			greymen_turn()
		else:
			momo_win("You are defeated!")

	elif is_isolating:
		display_text("You isolate Momo successfully!")
		await self.textbox_closed

		is_isolating = false

		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished

		display_text("Momo tries to attack you but no damage caused!")
		await self.textbox_closed

		greymen_turn()

	else:
		current_player_health = max(0, current_player_health - current_momo_damage)

		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished

		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PLAYER_MAX_HEALTH)

		display_text("Momo hits you for %d damage!" % current_momo_damage)
		await self.textbox_closed

		if current_player_health > 0:
			greymen_turn()
		else:
			momo_win("You are defeated!")

func _on_Attack_pressed():
	current_player_time -= attack_time

	if current_player_time >= 0:
		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time, GlobalState.stolen_time)

		display_text("You throw toy to Momo!")
		await self.textbox_closed

		current_momo_health = max(0, current_momo_health - GREYMEN_DAMAGE)
		set_health($MomoContainer/ProgressBar, current_momo_health, MOMO_HEALTH)

		AudioManager.hurt_sfx.play()

		$AnimationPlayer.play("momo_damaged")
		await $AnimationPlayer.animation_finished

		display_text("You dealt %d damage to Momo!" % GREYMEN_DAMAGE)
		await self.textbox_closed

		if current_momo_health <= 0:
			greymen_win("Momo was defeated!")
			return

		momo_turn()
	else:
		current_player_time += attack_time
		display_text("You don't have enough time to take this action!")
		await self.textbox_closed
		$ActionsPanel.show()

func _on_Defend_pressed():
	current_player_time -= defend_time

	if current_player_time >= 0:
		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time, GlobalState.stolen_time)
		is_defending = true
		momo_turn()
	else:
		current_player_time += defend_time
		momo_win("You don't have enough time! You lose!")

func _on_Isolate_pressed():
	current_player_time -= isolate_time

	if current_player_time >= 0:
		AudioManager.isolate_sfx.play()

		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time, GlobalState.stolen_time)

		is_isolating = true
		momo_turn()
	else:
		current_player_time += isolate_time
		display_text("The timeline collapses. You have no more time left to spend...")
		await self.textbox_closed
		$ActionsPanel.show()

func _on_Attack_mouse_entered() -> void:
	$Actionbox.show()
	$Actionbox/Attack.show()

func _on_Attack_mouse_exited() -> void:
	$Actionbox.hide()
	$Actionbox/Attack.hide()

func _on_Defend_mouse_entered() -> void:
	$Actionbox.show()
	$Actionbox/Defend.show()

func _on_Defend_mouse_exited() -> void:
	$Actionbox.hide()
	$Actionbox/Defend.hide()

func _on_Isolate_mouse_entered() -> void:
	$Actionbox.show()
	$Actionbox/Isolate.show()

func _on_Isolate_mouse_exited() -> void:
	$Actionbox.hide()
	$Actionbox/Isolate.hide()
