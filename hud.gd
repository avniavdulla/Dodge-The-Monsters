extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
var high_score: int = 0

func _ready():
	load_high_score()
	$HighScoreLabel.text = str(high_score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide() #hide the msg once its timed out

func set_High_Score(score: int):
	if score >= high_score:
		high_score = score
		$HighScoreLabel.text = str(high_score)
		save_score()
		
var save_path = "user://score.high_score"

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(high_score)
	
func load_high_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		print(file)
		high_score = file.get_var()
	else:
		print("file not found")
		high_score = 0

	
