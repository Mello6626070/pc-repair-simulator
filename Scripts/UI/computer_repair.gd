extends Control

@onready var component_label: Label = %ComponentLabel
@onready var comment_label: Label = %CommentLabel
@onready var cpu_view: PanelContainer = %CPUView
@onready var comment_header: Label = %CommentHeader


var target_pc: Computer
var pc_data_model: Quest

var animating_text: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_pc = get_parent().get_parent().target_pc
	target_pc.cant_boot.connect(cant_boot_emitted)
	set_selected_component(ComponentType.TYPE.NONE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animating_text and comment_label.visible_ratio < 1:
		var ratio = lerp(comment_label.visible_ratio, 1, 0.1)
		comment_label.visible_ratio = ratio
	else:
		animating_text = false

func hide_all() -> void:
	cpu_view.hide()

func set_selected_component(selected: ComponentType.TYPE) -> void:
	hide_all()
	match selected:
		ComponentType.TYPE.NONE:
			component_label.text = "System Unit"
		ComponentType.TYPE.CPU:
			component_label.text = "CPU"
			cpu_view.show()
	target_pc.set_selected_component(selected)
	if selected != ComponentType.TYPE.NONE:
		comment_component()
		comment_header.show()
		comment_label.show()
	else:
		comment_header.hide()
		comment_label.hide()

func comment_component() -> void:
	var text: String
	var state: ComponentState.STATE = target_pc.selected_component_state
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
	animating_text = true

func _on_check_cpu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.CPU)
func _on_check_ram_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.RAM)
func _on_check_gpu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.GPU)
func _on_check_storage_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.STORAGE)
func _on_check_psu_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.PSU)
func _on_check_cpu_cooler_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.CPU_COOLER)
func _on_check_exhaust_fan_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.EXHAUST_FANS)
func _on_check_intake_fan_button_pressed() -> void:
	set_selected_component(ComponentType.TYPE.INTAKE_FANS)
func _on_check_pc_pressed() -> void:
	set_selected_component(ComponentType.TYPE.NONE)

func cant_boot_emitted() -> void:
	pass
