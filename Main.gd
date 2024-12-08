extends Node

@export var mob_scene: PackedScene

@onready var spawn_location: PathFollow3D = $SpawnPath/SpawnLocation
@onready var player: CharacterBody3D = $Player
@onready var mob_timer: Timer = $MobTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob := mob_scene.instantiate()
	
	spawn_location.progress_ratio = randf()
	
	mob.initialize(spawn_location.position, player.position)
	add_child(mob)


func _on_player_hit() -> void:
	mob_timer.stop()
