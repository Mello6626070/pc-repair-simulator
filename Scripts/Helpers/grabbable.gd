class_name Grabbable extends RigidBody3D
signal grab_signal_recieved()
var player: CharacterBody3D
func grab(emitter: CharacterBody3D) -> void: 
	grab_signal_recieved.emit()
	player = emitter
