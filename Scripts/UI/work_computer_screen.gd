extends Control

@onready var login_screen: PanelContainer = %LoginScreen
@onready var home_screen: PanelContainer = %HomeScreen
@onready var work_screen: PanelContainer = %WorkScreen
@onready var shut_down_prompt: CenterContainer = %ShutDownPrompt
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX

var player: Player

func _ready() -> void:
	login_screen.show()
	player = get_parent().get_parent()

func _on_login_button_pressed() -> void:
	button_sfx.play()
	login_screen.hide()
	home_screen.show()

func _on_work_button_pressed() -> void:
	button_sfx.play()
	work_screen.show()

func _on_work_exit_button_pressed() -> void:
	button_sfx.play()
	work_screen.hide()

func _on_power_button_pressed() -> void:
	button_sfx.play()
	shut_down_prompt.show()

func _on_shutdown_button_pressed() -> void:
	button_sfx.play()
	var player: Player = get_parent().get_parent()
	player.current_state = 1
	queue_free()
	
func _on_yes_shut_down_button_pressed() -> void:
	button_sfx.play()
	var player: Player = get_parent().get_parent()
	player.current_state = 1
	if player.quest_selected:
		player.start_timer()
	queue_free()

func _on_no_shut_down_button_pressed() -> void:
	button_sfx.play()
	shut_down_prompt.hide()


func _on_work_screen_quest_accepted(quest: Quest) -> void:
	button_sfx.play()
	await button_sfx.finished
	player.quest_select(quest)
	player.current_state = 1
	if player.quest_selected:
		player.start_timer()
	player.quest_working = false
	queue_free()
