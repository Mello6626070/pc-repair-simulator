extends Node3D

@onready var computer: Computer = $Computer
@onready var computer_enabled_position: Node3D = $ComputerEnabledPosition
@onready var computer_disabled_position: Node3D = $ComputerDisabledPosition

var current_quest: Quest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computer.hide()
	computer.global_position = computer_disabled_position.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_post_selected_quest(quest: Quest) -> void:
	current_quest = quest
	computer.show()
	computer.global_position = computer_enabled_position.global_position
	computer.quest_data = current_quest
	computer.init_components()
