extends Node3D
@onready var button_click: AudioStreamPlayer = $ButtonClick
@onready var computer: Computer = $Computer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computer.toggle_case()
	computer.toggle_psu_power()
	computer.boot()

pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://Scenes/UI/loading_screen.tscn")


func _on_exit_button_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().quit()
