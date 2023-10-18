extends Area2D

var value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	prepareCoin()

func prepareCoin():
	var percent = randf()
	if percent > 0.9:
		value = 10
		$AnimatedSprite2D.animation = "ruby"
		$AnimatedSprite2D.play()
	elif percent > 0.7:
		value = 1
		$AnimatedSprite2D.animation = "silver"
		$AnimatedSprite2D.play()
	else:
		value = 3
		$AnimatedSprite2D.animation = "gold"
		$AnimatedSprite2D.play()
		
	$CollectValueLabel.text = "+" + str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.is_in_group("Player"):
		area.collect_coin(value)
		queue_free()
