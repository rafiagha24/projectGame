extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
var is_attacking := false
@onready var player_sprite: AnimatedSprite2D = $playerSprite2D
@onready var player_hit: Area2D = $playerHit


func _ready() -> void:
	player_sprite.frame_changed.connect(_on_frame_changed)

	player_hit.monitoring = false
	player_hit.body_entered.connect(_on_player_hit_body_entered)
	
	if Global.spawn_id == "entry":
		position = get_tree().get_first_node_in_group("entry").position
		Global.spawn_id = ""

func _on_player_hit_body_entered(body):
	print("KENA: ", body.name)

	if body.is_in_group("boss"):
		body.take_damage(1)

func _on_frame_changed():
	if player_sprite.animation == "attack":
		player_hit.monitoring = player_sprite.frame == 3
	else:
		player_hit.monitoring = false
		
func take_damage(amount):
	Global.player_health -= amount
	print("Player HP: ", Global.player_health)
	if Global.player_health <= 0:
		Global.player_health = 5
		get_tree().call_deferred("change_scene_to_file", "res://scenes/spawn.tscn")
		Global.boss = 1

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

		
	if Input.is_action_just_pressed("attack") and !is_attacking:
		is_attacking = true
		player_sprite.play("attack")

	if is_attacking and !player_sprite.is_playing():
		is_attacking = false

	# Gerak
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	if direction > 0:
		player_sprite.flip_h = false
		player_hit.position.x = abs(player_hit.position.x)
	elif direction < 0:
		player_sprite.flip_h = true
		player_hit.position.x = -abs(player_hit.position.x)

	if is_on_floor() and !is_attacking:
		if direction == 0:
			player_sprite.play("idle")
		else:
			player_sprite.play("run")
	elif !is_attacking:
		if player_sprite.animation != "jump":
			player_sprite.play("jump")


	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
