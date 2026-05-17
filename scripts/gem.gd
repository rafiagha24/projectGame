extends Node2D

@onready var spawn_door: Area2D = $spawnDoor
@export var door_id: String = "entry"
@onready var final: CharacterBody2D = $final

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_door.body_entered.connect(_on_door_body_entered)
	if Global.boss == 0:
		final.queue_free()

func _on_door_body_entered(body):
	if body.is_in_group("player"):
		Global.spawn_id = door_id
		get_tree().call_deferred("change_scene_to_file", "res://scenes/spawn.tscn")
