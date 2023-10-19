extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal player_chosen(index)

var high_score: int = 0
var last_selected: int = 0

func _ready():
	load_high_score()
	load_last_selected()
	set_last_selected_player()
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
	$RobertButton.show()
	$BlackCatButton.show()
	$OrangeCatButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	$RobertButton.hide()
	$BlackCatButton.hide()
	$OrangeCatButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide() #hide the msg once its timed out

func set_High_Score(score: int):
	if score >= high_score:
		high_score = score
		$HighScoreLabel.text = str(high_score)
		save_score()
		
var high_score_path = "user://score.high_score"

func save_score():
	var file = FileAccess.open(high_score_path, FileAccess.WRITE)
	file.store_var(high_score)
	
func load_high_score():
	if FileAccess.file_exists(high_score_path):
		print("file found")
		var file = FileAccess.open(high_score_path, FileAccess.READ)
		print(file)
		high_score = file.get_var()
	else:
		print("file not found")
		high_score = 0

var las_selected_path = "user://score.last_selected"
func save_last_selected():
	var file = FileAccess.open(las_selected_path, FileAccess.WRITE)
	file.store_var(last_selected)
		
func load_last_selected():
	if FileAccess.file_exists(las_selected_path):
		print("file found")
		var file = FileAccess.open(las_selected_path, FileAccess.READ)
		print(file)
		last_selected = file.get_var()
	else:
		print("file not found")
		last_selected = 0

func set_last_selected_player():
	get_tree().call_group("Select Player Buttons", "button_pressed = false")
	if last_selected == 0:
		_on_black_cat_button_pressed()
		$BlackCatButton.button_pressed = true
	elif last_selected == 1:
		_on_robert_button_pressed()
		$RobertButton.button_pressed = true
	elif last_selected == 2: 
		_on_orange_cat_button_pressed()
		$OrangeCatButton.button_pressed = true
	
func _on_black_cat_button_pressed():
	player_chosen.emit(0)
	last_selected = 0
	save_last_selected()
	$OrangeCatButton.button_pressed = false
	$RobertButton.button_pressed = false

func _on_robert_button_pressed():
	player_chosen.emit(1)
	last_selected = 1
	save_last_selected()
	$BlackCatButton.button_pressed = false
	$OrangeCatButton.button_pressed = false

func _on_orange_cat_button_pressed():
	player_chosen.emit(2)
	last_selected = 2
	save_last_selected()
	$BlackCatButton.button_pressed = false
	$RobertButton.button_pressed = false
