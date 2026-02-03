extends Control
@onready var panel: Panel = $Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel.show()
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	panel.hide()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	panel.show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Worlds/Office/office.tscn")
