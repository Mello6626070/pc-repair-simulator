class_name ComponentState extends Resource
enum STATE{
	OK,
	LOOSE,
	MISSING,
	DISCONNECTED,
	OFF,
	DIRTY
}
@export var state: STATE
