class_name Computer extends Node3D
signal cant_boot()
signal animation_finished()
signal winning_condition_achieved()
@onready var cpu: Node3D = %CartoonCPU
@onready var ram_1: Node3D = %CartoonRAM1
@onready var ram_2: Node3D = %CartoonRAM2
@onready var gpu: Node3D = %GPU
@onready var gpu_particle_emitter: GPUParticles3D = %GPUParticleEmitter
@onready var ssd: Node3D = %CartoonNVMESSD
@onready var cpu_cooler: Node3D = %CPUCooler
@onready var cpu_cooler_fan: Fan = %CPUCoolerFan
@onready var cpu_cooler_particle_emitter: GPUParticles3D = %CPUCoolerParticleEmitter
@onready var psu: MeshInstance3D = %PSU
@onready var psu_particle_emitter: GPUParticles3D = %PSUParticleEmitter
@onready var intake_fan_1: Fan = %IntakeFan1
@onready var intake_fan_1_particle_emitter: GPUParticles3D = %IntakeFan1ParticleEmitter
@onready var intake_fan_2: Fan = %IntakeFan2
@onready var intake_fan_2_particle_emitter_2: GPUParticles3D = %IntakeFan2ParticleEmitter2
@onready var exhaust_fan: Fan = %ExhaustFan
@onready var exhaust_fan_particle_emitter: GPUParticles3D = %ExhaustFanParticleEmitter
@onready var ray_cast_detector: StaticBody3D = $RayCastDetector
@onready var display_cable: Node3D = %DisplayCable
@onready var power_cable: Node3D = %PowerCable

@onready var cpu_selected_indicator: Node3D = %CPUSelectedIndicator
@onready var ram_selected_indicator: Node3D = %RAMSelectedIndicator
@onready var gpu_selected_indicator: Node3D = %GPUSelectedIndicator
@onready var ssd_selected_indicator: Node3D = %SSDSelectedIndicator
@onready var cpu_cooler_selected_indicator: Node3D = %CPUCoolerSelectedIndicator
@onready var psu_selected_indicator: Node3D = %PSUSelectedIndicator
@onready var exhaust_fan_selected_indicator: Node3D = %ExhaustFanSelectedIndicator
@onready var intake_fan_selected_indicator: Node3D = %IntakeFanSelectedIndicator
@onready var side_panel_fx: AudioStreamPlayer = $SidePanelFx
@onready var dirty_fan_fx: AudioStreamPlayer = $DirtyFanFx

@onready var animation_timer: Timer = %AnimationTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var fan_sf_x: AudioStreamPlayer = $FanSfX

@export var quest_data: Quest

var is_on: bool = false
var side_panel_installed: bool = true
var selected_component: ComponentType.TYPE
var selected_component_state: ComponentState.STATE
var previous_selected_component: ComponentType.TYPE
var next_animation: String
var doing_reinstall_animation: bool = false

@export var motherboard_state: ComponentState.STATE
@export var cpu_state: ComponentState.STATE
@export var ram_state: ComponentState.STATE
@export var gpu_state: ComponentState.STATE
@export var storage_state: ComponentState.STATE
@export var intake_fan_state: ComponentState.STATE
@export var exhaust_fan_state: ComponentState.STATE
@export var cpu_cooler_state: ComponentState.STATE
@export var psu_state: ComponentState.STATE
@export var display_cable_state: ComponentState.STATE
@export var power_cable_state: ComponentState.STATE
@export var usb_port_state: ComponentState.STATE
@export var wifi_state: ComponentState.STATE
@export var audio_state: ComponentState.STATE
@export var start_up_apps_state: ComponentState.STATE
@export var keyboard_state: ComponentState.STATE
@export var mouse_state: ComponentState.STATE
@export var headphone_state: ComponentState.STATE
@export var speaker_state: ComponentState.STATE
@export var mic_state: ComponentState.STATE
@export var disk_state: ComponentState.STATE
@export var os_state: ComponentState.STATE

func _ready() -> void:
	init_components()
	set_selected_component(ComponentType.TYPE.NONE)
	print(animation_player.get_animation_list())

func apply_quest_data() -> void:
	var initial_conditions: Array[ComponentType] = quest_data.initial_conditions
	for condition in initial_conditions:
		match condition.type:
			ComponentType.TYPE.CPU:
				cpu_state = condition.component_state.state
			ComponentType.TYPE.RAM:
				ram_state = condition.component_state.state
			ComponentType.TYPE.GPU:
				gpu_state = condition.component_state.state
			ComponentType.TYPE.DISPLAY_CABLE:
				display_cable_state = condition.component_state.state
			ComponentType.TYPE.PSU:
				psu_state = condition.component_state.state
			ComponentType.TYPE.POWER_CABLE:
				power_cable_state = condition.component_state.state
			ComponentType.TYPE.STORAGE:
				storage_state = condition.component_state.state
			ComponentType.TYPE.INTAKE_FANS:
				intake_fan_state = condition.component_state.state
			ComponentType.TYPE.EXHAUST_FANS:
				exhaust_fan_state = condition.component_state.state
			ComponentType.TYPE.CPU_COOLER:
				cpu_cooler_state = condition.component_state.state
			ComponentType.TYPE.USB_PORT:
				usb_port_state = condition.component_state.state
			ComponentType.TYPE.WIFI:
				wifi_state = condition.component_state.state
			ComponentType.TYPE.AUDIO:
				audio_state = condition.component_state.state
			ComponentType.TYPE.START_UP_APPS:
				start_up_apps_state = condition.component_state.state
			ComponentType.TYPE.KEYBOARD:
				keyboard_state = condition.component_state.state
			ComponentType.TYPE.MOUSE:
				mouse_state = condition.component_state.state
			ComponentType.TYPE.HEADPHONES:
				headphone_state = condition.component_state.state
			ComponentType.TYPE.SPEAKERS:
				speaker_state = condition.component_state.state
			ComponentType.TYPE.MICROPHONE:
				mic_state = condition.component_state.state
			ComponentType.TYPE.DISK:
				disk_state = condition.component_state.state
			ComponentType.TYPE.OPERATING_SYSTEM:
				os_state = condition.component_state.state

func check_pc_condition() -> void:
	var winning_condition: Array[ComponentType] = quest_data.winning_conditions
	var achieved: bool = false
	var achieved_list: Array[bool] = []
	for condition in winning_condition:
		match condition.type:
			ComponentType.TYPE.CPU:
				if cpu_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.RAM:
				if ram_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.GPU:
				if gpu_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.DISPLAY_CABLE:
				if display_cable_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.PSU:
				if psu_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.POWER_CABLE:
				if power_cable_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.STORAGE:
				if storage_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.INTAKE_FANS:
				if intake_fan_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.EXHAUST_FANS:
				if exhaust_fan_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.CPU_COOLER:
				if cpu_cooler_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.USB_PORT:
				if usb_port_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.WIFI:
				if wifi_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.AUDIO:
				if audio_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.START_UP_APPS:
				if start_up_apps_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.KEYBOARD:
				if keyboard_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.MOUSE:
				if mouse_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.HEADPHONES:
				if headphone_state == condition.component_state.state:
					achieved_list.append(true)
					print("TF")
				else:
					achieved_list.append(false)
			ComponentType.TYPE.SPEAKERS:
				if speaker_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.MICROPHONE:
				if mic_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.DISK:
				if disk_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
			ComponentType.TYPE.OPERATING_SYSTEM:
				if os_state == condition.component_state.state:
					achieved_list.append(true)
				else:
					achieved_list.append(false)
	for i in range(0, achieved_list.size()):
		if i == 0:
			achieved = achieved_list[i]
		else:
			achieved = achieved_list[i]
	if achieved:
		winning_condition_achieved.emit()
		print(achieved)

func init_components():
	update_cpu_visual()
	update_ram_visual()
	update_gpu_visual()
	update_ssd_visual()
	update_ssd_visual()
	update_cpu_cooler_visual()
	update_psu_visual()
	update_intake_fan_visual()
	update_exhaust_fan_visual()

func update_cpu_visual() -> void:
	match cpu_state:
		ComponentState.STATE.OK:
			cpu.show()
		ComponentState.STATE.MISSING:
			cpu.hide()

func update_ram_visual() -> void:
	match ram_state:
		ComponentState.STATE.OK:
			ram_1.show()
			ram_2.show()
		ComponentState.STATE.MISSING:
			ram_1.hide()
			ram_2.hide()
		ComponentState.STATE.LOOSE:
			animation_player.play("loose_ram_sway")

func update_gpu_visual() -> void:
	match gpu_state:
		ComponentState.STATE.OK:
			gpu.show()
			gpu_particle_emitter.emitting = false
			match display_cable_state:
				ComponentState.STATE.OK:
					display_cable.show()
				ComponentState.STATE.DISCONNECTED:
					display_cable.hide()
		ComponentState.STATE.DIRTY:
			gpu.show()
			gpu_particle_emitter.emitting = true
			match display_cable_state:
				ComponentState.STATE.OK:
					display_cable.show()
				ComponentState.STATE.DISCONNECTED:
					display_cable.hide()
		ComponentState.STATE.MISSING:
			gpu.hide()

func update_ssd_visual() -> void:
	match storage_state:
		ComponentState.STATE.OK:
			ssd.show()
		ComponentState.STATE.MISSING:
			ssd.hide()

func update_cpu_cooler_visual() -> void:
	match cpu_cooler_state:
		ComponentState.STATE.OK:
			cpu_cooler.show()
			cpu_cooler_particle_emitter.emitting = false
		ComponentState.STATE.OK:
			cpu_cooler.hide()
		ComponentState.STATE.DIRTY:
			cpu_cooler.show()
			cpu_cooler_particle_emitter.emitting = true

func update_psu_visual() -> void:
	match psu_state:
		ComponentState.STATE.OK, ComponentState.STATE.DISABLED:
			psu.show()
			psu_particle_emitter.emitting = false
			match power_cable_state:
				ComponentState.STATE.OK:
					power_cable.show()
				ComponentState.STATE.DISCONNECTED:
					power_cable.hide()
		ComponentState.STATE.DIRTY:
			psu.show()
			psu_particle_emitter.emitting = true
			match power_cable_state:
				ComponentState.STATE.OK:
					power_cable.show()
				ComponentState.STATE.DISCONNECTED:
					power_cable.hide()
		ComponentState.STATE.MISSING:
			psu.hide()

func update_intake_fan_visual() -> void:
	match intake_fan_state:
		ComponentState.STATE.OK:
			intake_fan_1.show()
			intake_fan_1_particle_emitter.emitting = false
			intake_fan_2.show()
			intake_fan_2_particle_emitter_2.emitting = false
		ComponentState.STATE.DIRTY:
			intake_fan_1.show()
			intake_fan_1_particle_emitter.emitting = true
			intake_fan_2.show()
			intake_fan_2_particle_emitter_2.emitting = true
		ComponentState.STATE.MISSING:
			intake_fan_1.hide()
			intake_fan_2.hide()

func update_exhaust_fan_visual() -> void:
	match exhaust_fan_state:
		ComponentState.STATE.OK:
			exhaust_fan.show()
			exhaust_fan_particle_emitter.emitting = false
		ComponentState.STATE.DIRTY:
			exhaust_fan.show()
			exhaust_fan_particle_emitter.emitting = true
		ComponentState.STATE.MISSING:
			exhaust_fan.hide()

func toggle_case() -> void:
	side_panel_fx.play()
	if side_panel_installed:
		animation_player.play_backwards("side_panel_install")
		side_panel_installed = false
	else:
		animation_player.play("side_panel_install")
		side_panel_installed = true

func _on_ray_cast_detector_interact_signal_recieved(player: Player) -> void:
	toggle_case()
	player.target_pc = self

func deselect_all() -> void:
	cpu_selected_indicator.hide()
	gpu_selected_indicator.hide()
	psu_selected_indicator.hide()
	ram_selected_indicator.hide()
	ssd_selected_indicator.hide()
	cpu_cooler_selected_indicator.hide()
	intake_fan_selected_indicator.hide()
	exhaust_fan_selected_indicator.hide()

func set_selected_component(component: ComponentType.TYPE) -> void:
	previous_selected_component = selected_component
	selected_component = component
	
	if previous_selected_component == ComponentType.TYPE.CPU:
		cpu_cooler.show()
	deselect_all()
	match selected_component:
		ComponentType.TYPE.NONE:
			pass
		ComponentType.TYPE.CPU:
			selected_component_state = cpu_state
			cpu_selected_indicator.show()
			cpu_cooler.hide()
		ComponentType.TYPE.RAM:
			selected_component_state = ram_state
			ram_selected_indicator.show()
		ComponentType.TYPE.GPU:
			selected_component_state = gpu_state
			gpu_selected_indicator.show()
		ComponentType.TYPE.PSU:
			selected_component_state = psu_state
			psu_selected_indicator.show()
		ComponentType.TYPE.STORAGE:
			selected_component_state = storage_state
			ssd_selected_indicator.show()
		ComponentType.TYPE.INTAKE_FANS:
			selected_component_state = intake_fan_state
			intake_fan_selected_indicator.show()
		ComponentType.TYPE.EXHAUST_FANS:
			selected_component_state = exhaust_fan_state
			exhaust_fan_selected_indicator.show()
		ComponentType.TYPE.CPU_COOLER:
			selected_component_state = cpu_cooler_state
			cpu_cooler_selected_indicator.show()
		ComponentType.TYPE.KEYBOARD:
			selected_component_state = keyboard_state
		ComponentType.TYPE.MOUSE:
			selected_component_state = mouse_state
		ComponentType.TYPE.SPEAKERS:
			selected_component_state = speaker_state
		ComponentType.TYPE.HEADPHONES:
			selected_component_state = headphone_state
		ComponentType.TYPE.MOUSE:
			selected_component_state = mouse_state

func install_animation(animation: String ,direction: String = "forward") -> void:
	match direction:
		"forward":
			animation_player.play(animation)
		"backward":
			animation_player.play_backwards(animation)

func do_remove_install_animation(animation: String) -> void:
	install_animation(animation, "backward")
	next_animation = animation
	doing_reinstall_animation = true

func _on_animation_timer_timeout() -> void:
	animation_player.play(next_animation)
	next_animation = ""

func hide_all_indicator() -> void:
	cpu_selected_indicator.hide()
	ram_selected_indicator.hide()
	gpu_selected_indicator.hide()
	ssd_selected_indicator.hide()
	cpu_cooler_selected_indicator.hide()
	psu_selected_indicator.hide()
	exhaust_fan_selected_indicator.hide()
	intake_fan_selected_indicator.hide()

func show_all_indicator() -> void:
	cpu_selected_indicator.show()
	ram_selected_indicator.show()
	gpu_selected_indicator.show()
	ssd_selected_indicator.show()
	cpu_cooler_selected_indicator.show()
	psu_selected_indicator.show()
	exhaust_fan_selected_indicator.show()
	intake_fan_selected_indicator.show()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if doing_reinstall_animation:
		animation_timer.start()
		doing_reinstall_animation = false
	else:
		match anim_name:
			"gpu_install": display_cable.show()
			"psu_install": power_cable.show()
		init_components()
		set_selected_component(selected_component)
		animation_finished.emit()

func reseat_cpu() -> void:
	do_remove_install_animation("cpu_install")
	if cpu_state == ComponentState.STATE.LOOSE:
		cpu_state = ComponentState.STATE.OK

func reseat_ram() -> void:
	do_remove_install_animation("ram_install")
	if ram_state == ComponentState.STATE.LOOSE:
		ram_state = ComponentState.STATE.OK

func reseat_gpu() -> void:
	do_remove_install_animation("gpu_install")
	display_cable.hide()
	if gpu_state == ComponentState.STATE.LOOSE:
		gpu_state = ComponentState.STATE.OK

func toggle_display_cable_connection() -> void:
	if display_cable_state == ComponentState.STATE.DISCONNECTED:
		display_cable_state = ComponentState.STATE.OK
		install_animation("display_cable_install")
	elif display_cable_state == ComponentState.STATE.OK:
		display_cable_state = ComponentState.STATE.DISCONNECTED
		install_animation("display_cable_install", "backward")

func clean_gpu() -> void:
	do_remove_install_animation("gpu_install")
	display_cable.hide()
	if gpu_state == ComponentState.STATE.DIRTY:
		gpu_state = ComponentState.STATE.OK

func reseat_storage() -> void:
	do_remove_install_animation("ssd_install")
	power_cable.hide()
	if storage_state == ComponentState.STATE.LOOSE:
		storage_state = ComponentState.STATE.OK

func clean_psu() -> void:
	do_remove_install_animation("psu_install")
	if psu_state == ComponentState.STATE.DIRTY:
		psu_state = ComponentState.STATE.DISABLED

func toggle_power_cable_connection() -> void:
	if power_cable_state == ComponentState.STATE.DISCONNECTED:
		power_cable_state = ComponentState.STATE.OK
		install_animation("power_cable_install")
	elif power_cable_state == ComponentState.STATE.OK:
		power_cable_state = ComponentState.STATE.DISCONNECTED
		install_animation("power_cable_install", "backward")

func toggle_psu_power() -> void:
	if psu_state == ComponentState.STATE.DISABLED:
		psu_state = ComponentState.STATE.OK
		selected_component_state = psu_state
	elif psu_state == ComponentState.STATE.OK:
		psu_state = ComponentState.STATE.DISABLED
		selected_component_state = psu_state

func clean_cpu_cooler() -> void:
	do_remove_install_animation("cpu_cooler_install")
	if cpu_cooler_state == ComponentState.STATE.DIRTY:
		cpu_cooler_state = ComponentState.STATE.OK

func clean_intake_fan() -> void:
	do_remove_install_animation("intake_fan_install")
	if intake_fan_state == ComponentState.STATE.DIRTY:
		intake_fan_state = ComponentState.STATE.OK

func clean_exhaust_fan() -> void:
	do_remove_install_animation("exhaust_fan_install")
	if exhaust_fan_state == ComponentState.STATE.DIRTY:
		exhaust_fan_state = ComponentState.STATE.OK

func boot() -> void:
	if !is_on:
		var psu_on: bool = psu_state != ComponentState.STATE.DISABLED
		var power_cable_connected: bool = power_cable_state == ComponentState.STATE.OK
		var display_connected: bool = display_cable_state == ComponentState.STATE.OK
		if psu_on and power_cable_connected and display_connected:
			cpu_cooler_fan.turn_fan_on()
			intake_fan_1.turn_fan_on()
			intake_fan_2.turn_fan_on()
			exhaust_fan.turn_fan_on()
			is_on = true
			fan_sf_x.play()
			if cpu_cooler_state == ComponentState.STATE.DIRTY or intake_fan_state == ComponentState.STATE.DIRTY or exhaust_fan_state == ComponentState.STATE.DIRTY:
				dirty_fan_fx.play()
			check_pc_condition()
		else:
			cant_boot.emit()
	else:
		cpu_cooler_fan.turn_fan_off()
		intake_fan_1.turn_fan_off()
		intake_fan_2.turn_fan_off()
		exhaust_fan.turn_fan_off()
		fan_sf_x.stop()
		dirty_fan_fx.stop()
		is_on = false

func toggle_keyboard() -> void:
	if keyboard_state == ComponentState.STATE.DISCONNECTED:
		keyboard_state = ComponentState.STATE.OK
	elif keyboard_state == ComponentState.STATE.OK:
		keyboard_state = ComponentState.STATE.DISCONNECTED
	selected_component_state = keyboard_state

func toggle_mouse() -> void:
	if mouse_state == ComponentState.STATE.DISCONNECTED:
		mouse_state = ComponentState.STATE.OK
	elif mouse_state == ComponentState.STATE.OK:
		mouse_state = ComponentState.STATE.DISCONNECTED
	selected_component_state = mouse_state

func toggle_speaker() -> void:
	if speaker_state == ComponentState.STATE.DISCONNECTED:
		speaker_state = ComponentState.STATE.OK
	elif speaker_state == ComponentState.STATE.OK:
		speaker_state = ComponentState.STATE.DISCONNECTED
	selected_component_state = speaker_state

func toggle_headphone() -> void:
	if headphone_state == ComponentState.STATE.DISCONNECTED:
		headphone_state = ComponentState.STATE.OK
	elif headphone_state == ComponentState.STATE.OK:
		headphone_state = ComponentState.STATE.DISCONNECTED
	selected_component_state = headphone_state

func toggle_mic() -> void:
	if mic_state == ComponentState.STATE.DISCONNECTED:
		mic_state = ComponentState.STATE.OK
	elif mic_state == ComponentState.STATE.OK:
		mic_state = ComponentState.STATE.DISCONNECTED
	selected_component_state = mic_state

func update_keyboard_driver() -> void:
	if keyboard_state == ComponentState.STATE.DISABLED:
		keyboard_state = ComponentState.STATE.OK

func update_mouse_driver() -> void:
	if mouse_state == ComponentState.STATE.DISABLED:
		mouse_state = ComponentState.STATE.OK

func update_wifi_driver() -> void:
	if wifi_state == ComponentState.STATE.DISABLED:
		wifi_state = ComponentState.STATE.OK

func update_gpu_driver() -> void:
	if gpu_state == ComponentState.STATE.DISABLED:
		gpu_state = ComponentState.STATE.OK

func update_usb_driver() -> void:
	if usb_port_state == ComponentState.STATE.DISABLED:
		usb_port_state = ComponentState.STATE.OK

func update_audio_driver() -> void:
	if audio_state == ComponentState.STATE.DISCONNECTED:
		audio_state = ComponentState.STATE.OK

func clear_disk_space() -> void:
	if disk_state == ComponentState.STATE.DISABLED:
		disk_state = ComponentState.STATE.OK

func run_chkdsk() -> void:
	if disk_state == ComponentState.STATE.DISCONNECTED:
		disk_state = ComponentState.STATE.OK

func run_defragment() -> void:
	if disk_state == ComponentState.STATE.MISSING:
		disk_state = ComponentState.STATE.OK

func toggle_mute() -> void:
	print("mute toggled")
	if audio_state == ComponentState.STATE.OK:
		audio_state = ComponentState.STATE.DISABLED
	elif audio_state == ComponentState.STATE.DISABLED:
		audio_state = ComponentState.STATE.OK

func disable_all_output() -> void:
	speaker_state = ComponentState.STATE.DISABLED
	headphone_state = ComponentState.STATE.DISABLED

func enable_speaker() -> void:
	speaker_state = ComponentState.STATE.OK
	headphone_state = ComponentState.STATE.DISABLED

func enable_headphone() -> void:
	speaker_state = ComponentState.STATE.DISABLED
	headphone_state = ComponentState.STATE.OK

func enable_mic() -> void:
	if mic_state == ComponentState.STATE.DISABLED:
		mic_state = ComponentState.STATE.OK

func disable_mic() -> void:
	if mic_state == ComponentState.STATE.OK:
		mic_state = ComponentState.STATE.DISABLED


func _on_fan_sf_x_finished() -> void:
	if is_on: fan_sf_x.play()

func _on_dirty_fan_fx_finished() -> void:
	if is_on:
		dirty_fan_fx.play()
