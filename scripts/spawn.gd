extends Node2D

@onready var main_door: Area2D = $mainDoor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_door.body_entered.connect(_on_door_body_entered)

func _on_door_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", "res://scenes/gem.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
