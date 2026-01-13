class_name Fan extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func turn_fan_on() -> void:
	animation_player.play("FanSpin")

func turn_fan_on_reverse() -> void:
	animation_player.play_backwards("FanSpin")

func turn_fan_off() -> void:
	animation_player.play("RESET")
