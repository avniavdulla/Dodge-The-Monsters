
extends Area2D
signal hit
signal collect(value)

@export var speed = 400 #pixels/s
@export var point_increase = 1
var screen_size #size of game window
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right") && !dead:
		velocity.x += 1
	if Input.is_action_pressed("move_left") && !dead:
		velocity.x -= 1
	if Input.is_action_pressed("move_down") && !dead:
		velocity.y += 1
	if Input.is_action_pressed("move_up") && !dead:
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "idle"
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "move"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		# MAKE GOING UP ANIMATION <--------------
		#$AnimatedSprite2D.animation = "fly"
		#$AnimatedSprite2D.flip_v = velocity.y > 0	
	
func start(pos):
	dead = false
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		dead = true
		hit.emit()
		$GPUParticles2D.position = position
		$GPUParticles2D.restart()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)


func collect_coin(value):
	collect.emit(value)

