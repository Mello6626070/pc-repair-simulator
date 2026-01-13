class_name ComponentType extends Resource
enum TYPE {
	NONE,
	CPU,
	RAM,
	GPU,
	DISPLAY_CABLE,
	PSU,
	POWER_CABLE,
	STORAGE,
	INTAKE_FANS,
	EXHAUST_FANS,
	CPU_COOLER,
	USB_PORT,
	WIFI,
	AUDIO,
	START_UP_APPS
}
@export var type: TYPE
@export var component_state: ComponentState
