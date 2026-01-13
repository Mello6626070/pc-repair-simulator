class_name Interactable extends StaticBody3D
signal interact_signal_recieved(player: Player)
var player: Player
@export var has_ui: bool
func interact(emitter: Player) -> void: 
	interact_signal_recieved.emit(emitter)
	player = emitter
