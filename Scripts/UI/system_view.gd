extends Control

signal system_exited()

@onready var start_panel: PanelContainer = %StartPanel
@onready var cpu_temp_label: Label = %CPUTempLabel
@onready var gpu_temp_label: Label = %GPUTempLabel
@onready var temps_panel: Control = %TempsPanel
@onready var loading_bar: ProgressBar = %LoadingBar
@onready var loading_panel: CenterContainer = %LoadingPanel
@onready var timer: Timer = %Timer
@onready var drivers_panel: Control = %DriversPanel
@onready var disk_panel: Control = %DiskPanel
@onready var disk_percentage_bar: ProgressBar = %DiskPercentageBar
@onready var output_selection: OptionButton = %OutputSelection
@onready var input_selection: OptionButton = %InputSelection
@onready var toggle_mute_button: Button = %ToggleMuteButton
@onready var audio_panel: Control = %AudioPanel
@onready var button_sfx_2: AudioStreamPlayer = $ButtonSFX2

var target_pc: Computer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loading_bar.value = timer.time_left


func _on_start_button_pressed() -> void:
	button_sfx_2.play()
	print("start button press")
	if start_panel.visible:
		start_panel.hide()
	else:
		start_panel.show()


func _on_cpu_temp_button_pressed() -> void:
	button_sfx_2.play()
	if temps_panel.visible:
		temps_panel.hide()
	else:
		var cpu_cooler_dirty: bool = target_pc.cpu_cooler_state == ComponentState.STATE.DIRTY
		var exhaust_fan_dirty: bool = target_pc.exhaust_fan_state == ComponentState.STATE.DIRTY
		var intake_fan_dirty: bool = target_pc.intake_fan_state == ComponentState.STATE.DIRTY
		var gpu_dirty: bool = target_pc.intake_fan_state == ComponentState.STATE.DIRTY
		
		cpu_temp_label.text = str(randi_range(40, 65), "C")
		gpu_temp_label.text = str(randi_range(40, 65), "C")
		
		if cpu_cooler_dirty or exhaust_fan_dirty or intake_fan_dirty:
			var rand_temp: int = randi_range(85, 100)
			cpu_temp_label.text = str(rand_temp, "C")
		
		if gpu_dirty or exhaust_fan_dirty or intake_fan_dirty:
			var rand_temp: int = randi_range(85, 100)
			gpu_temp_label.text = str(rand_temp, "C")
		
		temps_panel.show()

func _on_drivers_button_pressed() -> void:
	button_sfx_2.play()
	if drivers_panel.visible:
		drivers_panel.hide()
	else:
		drivers_panel.show()


func _on_disk_button_pressed() -> void:
	button_sfx_2.play()
	if disk_panel.visible:
		disk_panel.hide()
	else:
		if target_pc.disk_state == ComponentState.STATE.DISABLED:
			disk_percentage_bar.value = randf_range(80, 100)
		else:
			disk_percentage_bar.value = randf_range(50, 70)
		disk_panel.show()


func _on_audio_button_pressed() -> void:
	button_sfx_2.play()
	if audio_panel.visible:
		audio_panel.hide()
	else:
		update_mute_button()
		update_output_selection()
		update_input_selection()
		audio_panel.show()

func update_output_selection() -> void:
	button_sfx_2.play()
	if target_pc.speaker_state == ComponentState.STATE.DISABLED and target_pc.headphone_state == ComponentState.STATE.DISABLED:
		output_selection.selected = 0
	elif target_pc.speaker_state == ComponentState.STATE.OK and target_pc.headphone_state == ComponentState.STATE.DISABLED:
		output_selection.selected = 1
	elif target_pc.speaker_state == ComponentState.STATE.DISABLED and target_pc.headphone_state == ComponentState.STATE.OK:
		output_selection.selected = 2
	else:
		output_selection.selected = 1

func update_input_selection() -> void:
	button_sfx_2.play()
	if target_pc.mic_state == ComponentState.STATE.OK:
		input_selection.selected = 1
	elif target_pc.mic_state == ComponentState.STATE.DISABLED:
		input_selection.selected = 0

func _on_power_button_pressed() -> void:
	button_sfx_2.play()
	system_exited.emit()
	hide()


func _on_mouse_driver_update_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_mouse_driver()
	start_loading()


func _on_keyboard_driver_update_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_keyboard_driver()
	start_loading()


func _on_wifi_driver_update_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_wifi_driver()
	start_loading()


func _on_gpu_driver_update_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_gpu_driver()
	start_loading()


func _on_usb_driver_update_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_usb_driver()
	start_loading()


func _on_audio_driver_update_pressed() -> void:
	button_sfx_2.play()
	target_pc.update_usb_driver()
	start_loading()

func start_loading() -> void:
	loading_panel.show()
	timer.start()
	loading_bar.max_value = timer.wait_time

func _on_timer_timeout() -> void:
	button_sfx_2.play()
	loading_panel.hide()


func _on_visibility_changed() -> void:
	if visible:
		target_pc = get_parent().target_pc


func _on_clear_space_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.clear_disk_space()
	disk_percentage_bar.value = randf_range(50, 70)
	start_loading()


func _on_run_chkdsk_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.run_chkdsk()
	start_loading()

func _on_run_defragment_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.run_defragment()
	start_loading()

func _on_toggle_mute_button_pressed() -> void:
	button_sfx_2.play()
	target_pc.toggle_mute()
	update_mute_button()

func update_mute_button() -> void:
	button_sfx_2.play()
	if target_pc.audio_state == ComponentState.STATE.OK:
		toggle_mute_button.text = "MUTE"
	elif target_pc.audio_state == ComponentState.STATE.DISABLED:
		toggle_mute_button.text = "UNMUTE"


func _on_output_selection_item_selected(index: int) -> void:
	button_sfx_2.play()
	output_selection.selected = index
	match index:
		0: target_pc.disable_all_output()
		1: target_pc.enable_speaker()
		2: target_pc.enable_headphone()


func _on_input_selection_item_selected(index: int) -> void:
	button_sfx_2.play()
	input_selection.selected = index
	match index:
		0: target_pc.disable_mic()
		1: target_pc.enable_mic()
