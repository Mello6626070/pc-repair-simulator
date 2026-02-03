extends Control

@onready var panel: TextureRect = %Panel
@onready var component_label: Label = %ComponentLabel
@onready var comment_label: Label = %CommentLabel
@onready var cpu_view: PanelContainer = %CPUView
@onready var ram_view: PanelContainer = %RAMView
@onready var gpu_view: PanelContainer = %GPUView
@onready var storage_view: PanelContainer = %StorageView
@onready var psu_view: PanelContainer = %PSUView
@onready var cpu_cooler_view: PanelContainer = %CPUCoolerView
@onready var intake_fan_view: PanelContainer = %IntakeFanView
@onready var exhaust_fan_view: PanelContainer = %ExhaustFanView
@onready var system_unit_view: PanelContainer = %SystemUnitView
@onready var keyboard_view: PanelContainer = %KeyboardView
@onready var mouse_view: PanelContainer = %MouseView
@onready var speaker_view: PanelContainer = %SpeakerView
@onready var headphone_view: PanelContainer = %HeadphoneView
@onready var mic_view: PanelContainer = %MicView
@onready var cant_boot_warning: Control = %CantBootWarning
@onready var hardware: VBoxContainer = %Hardware
@onready var system: VBoxContainer = %System
@onready var finished_button: Button = %FinishedButton
@onready var comment_header: Label = %CommentHeader
@onready var finished_screen: Control = %FinishedScreen
@onready var time_label: Label = %TimeLabel
@onready var action_label: Label = %ActionLabel
@onready var score_label: Label = %ScoreLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var pc_button_click: AudioStreamPlayer = $PCButtonClick
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var win_sfx: AudioStreamPlayer = $WinSFX

@onready var system_view: Control = %SystemView


var target_pc: Computer
var pc_data_model: Quest

var animating_text: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_pc = get_parent().get_parent().target_pc
	target_pc.cant_boot.connect(pc_cant_boot)
	set_selected_component(ComponentType.TYPE.NONE)
	target_pc.animation_finished.connect(animation_finished)
	target_pc.winning_condition_achieved.connect(condition_achieved)
	if target_pc.is_on:
		hardware.hide()
		system.show()

func animation_finished() -> void:
	comment_component()
	show()

func pc_cant_boot() -> void:
	cant_boot_warning.show()

func condition_achieved() -> void:
	finished_button.show()
	print("ACHIEVED")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animating_text and comment_label.visible_ratio < 1:
		var ratio = lerp(comment_label.visible_ratio, 1, 0.1)
		comment_label.visible_ratio = ratio
	else:
		animating_text = false

func hide_all() -> void:
	cpu_view.hide()
	ram_view.hide()
	gpu_view.hide()
	storage_view.hide()
	psu_view.hide()
	cpu_cooler_view.hide()
	intake_fan_view.hide()
	exhaust_fan_view.hide()
	system_unit_view.hide()
	keyboard_view.hide()
	mouse_view.hide()
	speaker_view.hide()
	headphone_view.hide()
	mic_view.hide()

func set_selected_component(selected: ComponentType.TYPE) -> void:
	hide_all()
	match selected:
		ComponentType.TYPE.NONE:
			component_label.text = "System Unit"
			system_unit_view.show()
			if target_pc.is_on:
				comment_label.show()
			else:
				comment_label.hide()
		ComponentType.TYPE.CPU:
			component_label.text = "CPU"
			cpu_view.show()
		ComponentType.TYPE.RAM:
			component_label.text = "RAM"
			ram_view.show()
		ComponentType.TYPE.GPU:
			component_label.text = "GPU"
			gpu_view.show()
		ComponentType.TYPE.PSU:
			component_label.text = "PSU"
			psu_view.show()
		ComponentType.TYPE.STORAGE:
			component_label.text = "STORAGE"
			storage_view.show()
		ComponentType.TYPE.INTAKE_FANS:
			component_label.text = "INTAKE FANS"
			intake_fan_view.show()
		ComponentType.TYPE.EXHAUST_FANS:
			component_label.text = "EXHAUST FAN"
			exhaust_fan_view.show()
		ComponentType.TYPE.CPU_COOLER:
			component_label.text = "CPU COOLER"
			cpu_cooler_view.show()
		ComponentType.TYPE.KEYBOARD:
			component_label.text = "KEYBOARD"
			keyboard_view.show()
		ComponentType.TYPE.MOUSE:
			component_label.text = "MOUSE"
			mouse_view.show()
		ComponentType.TYPE.SPEAKERS:
			component_label.text = "SPEAKERS"
			speaker_view.show()
		ComponentType.TYPE.HEADPHONES:
			component_label.text = "HEADPHONES"
			headphone_view.show()
		ComponentType.TYPE.MICROPHONE:
			component_label.text = "MICROPHONE"
			mic_view.show()
	target_pc.set_selected_component(selected)
	if selected != ComponentType.TYPE.NONE:
		comment_component()
		comment_header.show()
		comment_label.show()
	else:
		comment_header.hide()

func comment_component() -> void:
	comment_label.show()
	var text: String
	var state: ComponentState.STATE = target_pc.selected_component_state
	if target_pc.selected_component == ComponentType.TYPE.GPU and target_pc.display_cable_state == ComponentState.STATE.DISCONNECTED:
		text = "The display cable isn't connected"
	elif target_pc.selected_component == ComponentType.TYPE.PSU and target_pc.power_cable_state == ComponentState.STATE.DISCONNECTED:
		text = "The power cable isn't connected"
	elif target_pc.selected_component == ComponentType.TYPE.PSU and target_pc.psu_state == ComponentState.STATE.DISABLED:
		text = "PSU is off"
	elif target_pc.selected_component == ComponentType.TYPE.NONE and target_pc.is_on:
		text = "System is on"
	elif target_pc.selected_component == ComponentType.TYPE.NONE and !target_pc.is_on:
		text = "System is off"
	elif target_pc.selected_component == ComponentType.TYPE.NONE:
		comment_label.hide()
	else:
		match state:
			ComponentState.STATE.OK:
				text = "It seems okay"
			ComponentState.STATE.LOOSE:
				text = "The connection seems loose"
			ComponentState.STATE.MISSING:
				text = "It's not here"
			ComponentState.STATE.DISCONNECTED:
				text = "It's disconnected"
			ComponentState.STATE.DIRTY:
				text = "It's dirty"
			ComponentState.STATE.DISABLED:
				text = "It's turned off"
	comment_label.text = text

func _on_check_cpu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.CPU)
	button_sfx.play()
func _on_check_ram_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.RAM)
	button_sfx.play()
func _on_check_gpu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.GPU)
	button_sfx.play()
func _on_check_storage_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.STORAGE)
	button_sfx.play()
func _on_check_psu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.PSU)
	button_sfx.play()
func _on_check_cpu_cooler_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.CPU_COOLER)
	button_sfx.play()
func _on_check_exhaust_fan_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.EXHAUST_FANS)
	button_sfx.play()
func _on_check_intake_fan_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.INTAKE_FANS)
	button_sfx.play()
func _on_check_pc_pressed() -> void:
	set_selected_component(ComponentType.TYPE.NONE)
	button_sfx.play()
	
func look_at_the_pc() -> void:
	pass


func _on_reseat_cpu_button_pressed() -> void:
	button_sfx.play()
	target_pc.reseat_cpu()
	comment_component()
	hide()

func _on_reseat_ram_button_pressed() -> void:
	button_sfx.play()
	target_pc.reseat_ram()
	comment_component()
	hide()


func _on_reseat_gpu_button_pressed() -> void:
	button_sfx.play()
	target_pc.reseat_gpu()
	comment_component()
	hide()


func _on_connect_display_cable_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_display_cable_connection()
	comment_component()
	hide()


func _on_clean_gpu_button_pressed() -> void:
	button_sfx.play()
	target_pc.clean_gpu()
	comment_component()
	hide()


func _on_reseat_storage_button_pressed() -> void:
	button_sfx.play()
	target_pc.reseat_storage()
	comment_component()
	hide()


func _on_clean_psu_button_pressed() -> void:
	button_sfx.play()
	target_pc.clean_psu()
	comment_component()
	hide()


func _on_connect_power_cable_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_power_cable_connection()
	comment_component()
	hide()


func _on_turn_onpsu_button_pressed() -> void:
	button_sfx.play()
	pc_button_click.play()
	target_pc.toggle_psu_power()
	comment_component()


func _on_clean_cpu_cooler_button_pressed() -> void:
	button_sfx.play()
	target_pc.clean_cpu_cooler()
	comment_component()
	hide()


func _on_clean_intake_fan_button_pressed() -> void:
	button_sfx.play()
	target_pc.clean_intake_fan()
	comment_component()
	hide()


func _on_clean_exhaust_fan_button_pressed() -> void:
	button_sfx.play()
	target_pc.clean_exhaust_fan()
	comment_component()
	hide()


func _on_turn_pc_on_button_pressed() -> void:
	target_pc.boot()
	comment_component()
	pc_button_click.play()
	if target_pc.is_on:
		hardware.hide()
		system.show()
	else:
		hardware.show()
		system.hide()


func _on_cant_boot_warning_okay_button_pressed() -> void:
	cant_boot_warning.hide()


func _on_exit_button_pressed() -> void:
	button_sfx.play()
	await button_sfx.finished
	var player: Player = get_parent().get_parent()
	target_pc.toggle_case()
	player.current_state = 1
	queue_free()


func _on_finished_button_pressed() -> void:
	button_sfx.play()
	finished_screen.show()
	var player: Player = get_parent().get_parent()
	win_sfx.play()
	player.task_label.hide()
	player.stop_timer()
	time_label.text = str("Time: ", player.time)
	score_label.text = str("Score: ", calculate_score(player.time))

func calculate_score(time: int) -> float:
	var base_score: float = 10000
	return int(base_score/time)

func _on_finished_panel_button_pressed() -> void:
	button_sfx.play()
	var player: Player = get_parent().get_parent()
	panel.show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	player.post_quest_finished.emit()
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
	target_pc.toggle_case()
	player.current_state = 1
	player.quest_selected = false
	queue_free()


func _on_check_keyboard_pressed() -> void:
	button_sfx.play()
	set_selected_component(ComponentType.TYPE.KEYBOARD)


func _on_check_mouse_pressed() -> void:
	button_sfx.play()
	set_selected_component(ComponentType.TYPE.MOUSE)


func _on_check_speaker_pressed() -> void:
	button_sfx.play()
	set_selected_component(ComponentType.TYPE.SPEAKERS)


func _on_check_headphone_pressed() -> void:
	button_sfx.play()
	set_selected_component(ComponentType.TYPE.HEADPHONES)


func _on_check_mic_pressed() -> void:
	button_sfx.play()
	set_selected_component(ComponentType.TYPE.MICROPHONE)


func _on_toggle_keyboard_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_keyboard()
	comment_component()


func _on_toggle_mouse_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_mouse()
	comment_component()


func _on_toggle_speaker_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_speaker()
	comment_component()


func _on_toggle_headphone_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_headphone()
	comment_component()


func _on_toggle_mic_button_pressed() -> void:
	button_sfx.play()
	target_pc.toggle_mic()
	comment_component()


func _on_open_system_button_pressed() -> void:
	button_sfx.play()
	system_view.show()
	system_view.target_pc = target_pc


func _on_system_view_system_exited() -> void:
	button_sfx.play()
	target_pc.check_pc_condition()
