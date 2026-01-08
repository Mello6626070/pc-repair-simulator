extends Control

@onready var login_screen: PanelContainer = %LoginScreen
@onready var home_screen: PanelContainer = %HomeScreen
@onready var work_screen: PanelContainer = %WorkScreen
@onready var shut_down_prompt: CenterContainer = %ShutDownPrompt


func _ready() -> void:
	login_screen.show()

func _on_login_button_pressed() -> void:
	login_screen.hide()
	home_screen.show()

func _on_work_button_pressed() -> void:
	work_screen.show()

func _on_work_exit_button_pressed() -> void:
	work_screen.hide()

func _on_power_button_pressed() -> void:
	shut_down_prompt.show()

func _on_shutdown_button_pressed() -> void:
	var player: Player = get_parent().get_parent()
	player.current_state = 1
	queue_free()
	
func _on_yes_shut_down_button_pressed() -> void:
	var player: Player = get_parent().get_parent()
	player.current_state = 1
	queue_free()

func _on_no_shut_down_button_pressed() -> void:
	shut_down_prompt.hide()
