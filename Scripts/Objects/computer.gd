class_name Computer extends Node3D
signal cant_boot()

@export var quest_data: Quest

var is_on: bool = false
var side_panel_installed: bool = true
@export var motherboard_state: ComponentState
@export var cpu_state: ComponentState
@export var ram_state: ComponentState
@export var gpu_state: ComponentState
@export var storage_state: ComponentState
@export var intake_fan_state: ComponentState
@export var exhaust_fan_state: ComponentState
@export var cpu_cooler_state: ComponentState
@export var psu_state: ComponentState
@export var display_cable_state: ComponentState
@export var power_cable_state: ComponentState
@export var usb_port_state: ComponentState
@export var wifi_state: ComponentState
@export var audio_state: ComponentState
@export var start_up_apps_state: ComponentState

func apply_quest_data() -> void:
	var initial_conditions: Array[ComponentType] = quest_data.initial_conditions
	for condition in initial_conditions:
		match condition.type:
			ComponentType.TYPE.CPU:
				cpu_state = condition.component_state
			ComponentType.TYPE.RAM:
				ram_state = condition.component_state
			ComponentType.TYPE.GPU:
				gpu_state = condition.component_state
			ComponentType.TYPE.DISPLAY_CABLE:
				display_cable_state = condition.component_state
			ComponentType.TYPE.PSU:
				psu_state = condition.component_state
			ComponentType.TYPE.POWER_CABLE:
				power_cable_state = condition.component_state
			ComponentType.TYPE.STORAGE:
				storage_state = condition.component_state
			ComponentType.TYPE.INTAKE_FANS:
				intake_fan_state = condition.component_state
			ComponentType.TYPE.EXHAUST_FANS:
				exhaust_fan_state = condition.component_state
			ComponentType.TYPE.CPU_COOLER:
				cpu_cooler_state = condition.component_state
			ComponentType.TYPE.USB_PORT:
				usb_port_state = condition.component_state
			ComponentType.TYPE.WIFI:
				wifi_state = condition.component_state
			ComponentType.TYPE.AUDIO:
				audio_state = condition.component_state
			ComponentType.TYPE.START_UP_APPS:
				start_up_apps_state = condition.component_state

func update_components():
	pass
