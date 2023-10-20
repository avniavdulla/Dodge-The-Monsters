extends Node

## Runs the main game logic 

@export var player_scenes: Array[PackedScene] 
@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
var selected_player
var player_index = 0
var score = 0
var high_score = 0
static var background_base = "res://art/backgrounds/background"

## Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player()
	randomize()
	$BackgroundTexture.set_texture(load(background_base + str(randi() % 7) + ".jpg" ))


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## called when the player is hit by the enemies 
func game_over():
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CoinTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$HUD.set_High_Score(score)
	get_tree().call_group("Collectable", "queue_free")

func new_game():
	get_tree().call_group("Enemy", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	selected_player.start($StartPosition.position)
	$StartTimer.start()
	$CoinTimer.start()
	$Music.play()
	$BackgroundTexture.set_texture(load(background_base + str(randi() % 9) + ".jpg" ))


func _on_score_timer_timeout():
	score += selected_player.point_increase
	$HUD.update_score(score)
	if score % 50 == 0 && score != 0: 
		$BackgroundTexture.set_texture(load(background_base + str(randi() % 9) + ".jpg" ))

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func spawn_player(): 
	var scene = player_scenes[player_index]
	selected_player = scene.instantiate()
	selected_player.hit.connect(game_over)
	selected_player.collect.connect(_on_player_collect)
	add_child(selected_player)

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	

func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	
	var randomLocationX = randf_range(10.0, 460)
	var randomLocationY = randf_range(10.0, 700)
	$CoinTimer.stop()
	coin.position = Vector2(randomLocationX, randomLocationY)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(coin)

func _on_player_collect(value: int):
	$CoinSound.play()
	$CoinTimer.start()
	score += value
	$HUD.update_score(score)
	

func _on_hud_player_chosen(index):
	remove_child(selected_player)
	player_index = index
	spawn_player()
