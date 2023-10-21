extends CanvasLayer

class_name HUD

## Script for controlling the HUD 

## controls how the buttons interact with the game 
## controls showing/updating score 

## Notifies `Main` node that it should start the game
signal start_game
## Notifies game that the pause menu is up
signal pause_game(val: bool)
## Notifies the game when the player is chosen 
signal player_chosen(index)

## High score for this user, saved to disk and persists through restarts 
var high_score: int = 0
## last selected player for the user, saved to disk and persists through restarts 
var last_selected_player: int = 0

func _ready():
	high_score = load_from_disc("high_score")
	last_selected_player = load_from_disc("last_selected_player")
	set_last_selected_player()
	save_to_disc(last_selected_player, "last_selected_player" )
	$HighScoreLabel.text = str(high_score)

## Show the given mesage for the length of the timer
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

## Ends the game 
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$RobertButton.show()
	$BlackCatButton.show()
	$OrangeCatButton.show()
	
## Update the text label according to the given score 
func update_score(score: int):
	$ScoreLabel.text = str(score)

## Sets the high score with the given score 
func set_High_Score(score: int):
	if score >= high_score:
		high_score = score
		$HighScoreLabel.text = str(high_score)
		save_to_disc(score, "high_score" )

## Called when main START button is clicked
func _on_start_button_pressed():
	$StartButton.hide()
	$RobertButton.hide()
	$BlackCatButton.hide()
	$OrangeCatButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide() #hide the msg once its timed out

##################################################################
### Save / Load functionality ###
##################################################################

## Save the variable at the given path 
## creates the file if it does not exist
func save_to_disc(value, path): 
	var file = FileAccess.open($Constants.save_paths[path], FileAccess.WRITE)
	file.store_var(value)

## Load the variable at the given path 
## defaults to zero if no file is found at that path
func load_from_disc(path):
	if FileAccess.file_exists($Constants.save_paths[path]):
		print("file found")
		var file = FileAccess.open($Constants.save_paths[path], FileAccess.READ)
		return file.get_var()
	else:
		return 0

##################################################################
### SELECTING THE PLAYER CHAR ### 
##################################################################
func set_last_selected_player():
	get_tree().call_group("Select Player Buttons", "button_pressed = false")
	if last_selected_player == 0:
		_on_black_cat_button_pressed()
		$BlackCatButton.button_pressed = true
	elif last_selected_player == 1:
		_on_robert_button_pressed()
		$RobertButton.button_pressed = true
	elif last_selected_player == 2: 
		_on_orange_cat_button_pressed()
		$OrangeCatButton.button_pressed = true

func _on_black_cat_button_pressed():
	player_chosen.emit(0)
	last_selected_player = 0
	save_to_disc(last_selected_player, "last_selected_player" )
	$OrangeCatButton.button_pressed = false
	$RobertButton.button_pressed = false

func _on_robert_button_pressed():
	player_chosen.emit(1)
	last_selected_player = 1
	save_to_disc(last_selected_player,  "last_selected_player" )
	$BlackCatButton.button_pressed = false
	$OrangeCatButton.button_pressed = false

func _on_orange_cat_button_pressed():
	player_chosen.emit(2)
	last_selected_player = 2
	save_to_disc(last_selected_player,  "last_selected_player" )
	$BlackCatButton.button_pressed = false
	$RobertButton.button_pressed = false

func _on_settings_button_toggled(button_pressed):
	if $Settings.is_visible_in_tree():
		$Settings.hide()
		get_tree().paused = false
	else: 
		$Settings.show()
		get_tree().paused = true
