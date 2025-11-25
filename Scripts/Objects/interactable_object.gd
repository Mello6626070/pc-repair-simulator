extends Interactable



var toggle: bool = false
@onready var label_3d: Label3D = $Label3D

func _on_interact_signal_recieved() -> void:
	toggle = not toggle
	
	if toggle:
		label_3d.show()
	else:
		label_3d.hide()
