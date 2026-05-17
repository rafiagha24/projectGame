extends Area2D

const SPEED = 200.0
var direction = -1

func _ready():
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	monitoring = true

func _process(delta):
	position.x += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(1)  # kurangi hp player
		queue_free()          # hapus bullet
