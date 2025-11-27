class_name Grabbable extends RigidBody3D
signal grab_signal_recieved()
var player: Player
func grab(emitter: Player) -> void: 
	grab_signal_recieved.emit()
	player = emitter
