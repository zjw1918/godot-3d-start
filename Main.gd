extends Node

@export var mob_scene: PackedScene

@onready var spawn_location: PathFollow3D = $SpawnPath/SpawnLocation
@onready var player: CharacterBody3D = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var score_label: Label = $UserInterface/ScoreLabel
@onready var retry: ColorRect = $UserInterface/Retry


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob := mob_scene.instantiate()
	
	spawn_location.progress_ratio = randf()
	
	mob.initialize(spawn_location.position, player.position)
	add_child(mob)
	
	(mob as Mob).squashed.connect(score_label._on_mob_squashed.bind())


func _on_player_hit() -> void:
	mob_timer.stop()
	retry.show()
