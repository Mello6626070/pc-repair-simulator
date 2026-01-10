extends Interactable

@export var ui_scene: PackedScene
func _ready() -> void:
	has_ui = false
func _on_interact_signal_recieved() -> void:
	pass
