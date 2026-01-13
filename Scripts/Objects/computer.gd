class_name Computer extends Node3D
signal cant_boot()

@onready var cpu: Node3D = %CartoonCPU
@onready var ram_1: Node3D = %CartoonRAM1
@onready var ram_2: Node3D = %CartoonRAM2
@onready var gpu: Node3D = %GPU
@onready var ssd: Node3D = %CartoonNVMESSD
@onready var cpu_cooler: Node3D = %CPUCooler
@onready var cpu_cooler_particle_emitter: GPUParticles3D = %CPUCoolerParticleEmitter
@onready var psu: MeshInstance3D = %PSU
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

@onready var animation_timer: Timer = %AnimationTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

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

func _ready() -> void:
	init_components()
	set_selected_component(ComponentType.TYPE.NONE)

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
			match display_cable_state:
				ComponentState.STATE.OK:
					display_cable.show()
				ComponentState.STATE.MISSING:
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
			match power_cable_state:
				ComponentState.STATE.OK:
					power_cable.show()
				ComponentState.STATE.MISSING:
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
		animation_player.play("cpu_cooler_install")
	
	match selected_component:
		ComponentType.TYPE.NONE:
			deselect_all()
		ComponentType.TYPE.CPU:
			selected_component_state = cpu_state
			deselect_all()
			cpu_selected_indicator.show()
			animation_player.play_backwards("cpu_cooler_install")
		ComponentType.TYPE.RAM:
			selected_component_state = ram_state
			deselect_all()
			ram_selected_indicator.show()
		ComponentType.TYPE.GPU:
			selected_component_state = gpu_state
			deselect_all()
			gpu_selected_indicator.show()
		ComponentType.TYPE.PSU:
			selected_component_state = psu_state
			deselect_all()
			psu_selected_indicator.show()
		ComponentType.TYPE.STORAGE:
			selected_component_state = storage_state
			deselect_all()
			ssd_selected_indicator.show()
		ComponentType.TYPE.INTAKE_FANS:
			selected_component_state = intake_fan_state
			deselect_all()
			intake_fan_selected_indicator.show()
		ComponentType.TYPE.EXHAUST_FANS:
			selected_component_state = exhaust_fan_state
			deselect_all()
			exhaust_fan_selected_indicator.show()
		ComponentType.TYPE.CPU_COOLER:
			selected_component_state = cpu_cooler_state
			deselect_all()
			cpu_cooler_selected_indicator.show()

func install_animation(animation: String ,direction: String = "forward") -> void:
	match direction:
		"forward":
			animation_player.play(animation)
		"backward":
			animation_player.play_backwards(animation)

func do_remove_install_animation(animation: String) -> void:
	install_animation(animation, "forward")
	next_animation = animation
	doing_reinstall_animation = true

func _on_animation_timer_timeout() -> void:
	animation_player.play_backwards(next_animation)
	next_animation = ""


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if doing_reinstall_animation:
		animation_timer.start(1)
		doing_reinstall_animation = false
