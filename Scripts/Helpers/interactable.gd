class_name Interactable extends StaticBody3D
signal interact_signal_recieved()
var player: CharacterBody3D

func interact(emitter: CharacterBody3D) -> void: 
	interact_signal_recieved.emit()
	player = emitter
