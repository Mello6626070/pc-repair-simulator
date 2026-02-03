extends Node3D

@onready var computer: Computer = $Computer
@onready var computer_enabled_position: Node3D = $ComputerEnabledPosition
@onready var computer_disabled_position: Node3D = $ComputerDisabledPosition
@onready var player: Player = %Player
@onready var bg_music: AudioStreamPlayer = $BGMusic

var current_quest: Quest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	computer.hide()
	computer.global_position = computer_disabled_position.global_position
	#player.rotation.y = 180


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_post_selected_quest(quest: Quest) -> void:
	current_quest = quest
	computer.show()
	computer.global_position = computer_enabled_position.global_position
	computer.quest_data = current_quest
	computer.apply_quest_data()
	computer.init_components()


func _on_player_post_quest_finished() -> void:
	current_quest = null
	computer.hide()
	computer.global_position = computer_disabled_position.global_position
	computer.boot()
	computer.init_components()

func _on_bg_music_finished() -> void:
	bg_music.play()


func _on_player_timer_timeout() -> void:
	current_quest = null
	computer.hide()
	computer.global_position = computer_disabled_position.global_position
	computer.boot()
	computer.init_components()
