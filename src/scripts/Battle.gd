extends Control

signal textbox_closed

var current_player_health = 0
var current_player_time = 0
var current_momo_health = 0
var is_defending = false

var attack_time = 10
var defend_time = 5
var run_time = 10

func _ready():
	set_health($MomoContainer/ProgressBar, State.momo_health, State.momo_health)
	set_time($PlayerPanel/PlayerData/TimeBar, State.current_time,State.max_time)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)

	
	current_player_health = State.current_health
	current_player_time = State.current_time
	current_momo_health = State.momo_health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("%s appears! Defeat her with your stolen time!" % State.momo_name)
	await self.textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func set_time(progress_bar, curent_time, max_time):
	progress_bar.value = curent_time
	progress_bar.max_value = max_time
	progress_bar.get_node("Label").text = "Time: %d/%d" % [curent_time, max_time]	

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func momo_turn():
	display_text("%s launches at you fiercely!" % State.momo_name)
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		var defend_damage = randi_range(0,State.momo_damage)
		current_player_health = max(0, current_player_health - defend_damage)
		if current_player_health > 0:
			display_text("You defended successfully!")
			display_text("%s dealt %d damage!" % [State.momo_name, defend_damage])
			await self.textbox_closed
		else :
			momo_win("You are defeated!")		
	else:
		current_player_health = max(0, current_player_health - State.momo_damage)
		if current_player_health > 0:
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
			$AnimationPlayer.play("shake")
			await $AnimationPlayer.animation_finished
			display_text("%s dealt %d damage!" % [State.momo_name, State.momo_damage])
			await self.textbox_closed
		else :
			momo_win("You are defeated!")	
	$ActionsPanel.show()

func momo_win(text):
	display_text(text)
	await self.textbox_closed
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()	
	
func _on_Run_pressed():
	current_player_time = current_player_time - run_time
	if current_player_time >= 0:
		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time,State.max_time)
		display_text("Got away safely!")
		await self.textbox_closed
		
		momo_turn()
	else:
		momo_win("You don't have enough time! You lose!")
		
func _on_Attack_pressed():
	current_player_time = current_player_time - attack_time
	if current_player_time >= 0:
		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time,State.max_time)
		display_text("You swing your piercing sword!")
		await self.textbox_closed
		
		current_momo_health = max(0, current_momo_health - State.greymen_damage)
		set_health($MomoContainer/ProgressBar, current_momo_health, State.momo_health)
		
		#$AnimationPlayer.play("momo_damaged")
		#await $AnimationPlayer.animation_finished
	
		display_text("You dealt %d damage!" % State.greymen_damage)
		await self.textbox_closed
	
		if current_momo_health <= 0:
			display_text("%s was defeated!" % State.momo_name)
			await self.textbox_closed
		
			$AnimationPlayer.play("momo_lose")
			await $AnimationPlayer.animation_finished
		
			await get_tree().create_timer(0.25).timeout
			get_tree().quit()

		momo_turn()
	else:
		momo_win("You don't have enough time! You lose!")	

func _on_Defend_pressed():
	current_player_time = current_player_time - defend_time
	if current_player_time >= 0:
		set_time($PlayerPanel/PlayerData/TimeBar, current_player_time,State.max_time)
		is_defending = true
	
		display_text("You prepare defensively!")
		await self.textbox_closed
	
		await get_tree().create_timer(0.25).timeout
	
		momo_turn()
		
	else:
		momo_win("You don't have enough time! You lose!")	
