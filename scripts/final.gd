extends CharacterBody2D

@onready var shoot_points = [$shootPoint1, $shootPoint2]
@onready var shoot_timer = $shootTimer
@onready var final_knock: Area2D = $finalKnock

var final_health = 5

var projectile_scene = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	final_knock.body_entered.connect(_on_final_knock_body_entered)

func _on_final_knock_body_entered(body):
	if body.is_in_group("player"):
		shoot_timer.start()

func _on_shoot_timer_timeout():
	shoot()

func take_damage(amount):
	
	final_health -= amount
	print("Boss HP: ", final_health)
	if final_health <= 0:
		queue_free()
		Global.boss = 0

func shoot():
	var point = shoot_points.pick_random()
	var bullet = projectile_scene.instantiate()
	bullet.position = point.global_position
	bullet.direction = -1
	get_parent().add_child(bullet)
