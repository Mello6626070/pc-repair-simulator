extends Grabbable

func _on_grab_signal_recieved() -> void:
	queue_free()
