class_name ComponentType extends Resource
enum TYPE {
	CPU,
	RAM,
	GPU,
	STORAGE,
	PSU,
	POWER_CABLE,
	CPU_COOLER,
	FAN
}
@export var type: TYPE
