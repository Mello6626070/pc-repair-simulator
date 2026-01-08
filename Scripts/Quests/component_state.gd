class_name ComponentState extends Resource
enum STATE{
	OK,
	LOOSE,
	MISSING,
	DISCONNECTED,
	DIRTY,
	DISABLED
}
@export var state: STATE
