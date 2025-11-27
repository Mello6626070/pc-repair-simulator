extends Control


func _on_exit_button_pressed() -> void:
	var player: Player = get_parent().get_parent()
	player.current_state = 1
	queue_free()
