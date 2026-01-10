class_name Player extends CharacterBody3D

@export_category("Camera Stuff")
@export var mouse_sens: float = 0.5
@export var MAX_TILT: float = deg_to_rad(90)
@export var MIN_TILT: float = deg_to_rad(-90)

@export_category("Player Movemenent")
@export var SPEED: float = 5.0

@onready var camera_container: Node3D = $CameraContainer
@onready var interaction_ray_cast: RayCast3D = $CameraContainer/InteractionRayCast
@onready var interactable_indicator: Label = $HUD/InteractableIndicator
@onready var interactables_ui: CanvasLayer = $InteractablesUI

enum States{
	NORMAL = 1,
	ON_UI = 2
}

var mouse_input: bool = false
var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var player_rotation: Vector3
var camera_rotation: Vector3
var current_state: int

func _ready() -> void:
	current_state = States.NORMAL
	print("mouse captured")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion && Input.mouse_mode && current_state == States.NORMAL
	if mouse_input:
		rotation_input = -event.relative.x * mouse_sens
		tilt_input = -event.relative.y * mouse_sens

func update_camera(delta) -> void:
	mouse_rotation.x += tilt_input*delta
	mouse_rotation.x = clamp(mouse_rotation.x, MIN_TILT, MAX_TILT)
	mouse_rotation.y += rotation_input*delta
	
	player_rotation = Vector3(0, mouse_rotation.y, 0)
	camera_rotation = Vector3(mouse_rotation.x, 0, 0)
	
	camera_container.transform.basis = Basis.from_euler(camera_rotation)
	camera_container.rotation.z = 0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0
	tilt_input = 0

func interact_cast():
	interactable_indicator.hide()
	if interaction_ray_cast.is_colliding() && current_state == States.NORMAL:
		var target = interaction_ray_cast.get_collider()
		var type: String
		if target:
			if target.has_method("grab"):
				interactable_indicator.text = "Press E to grab"
				type = "grabbable"
			elif target.has_method("interact"):
				interactable_indicator.text = "Press E to interact"
				type = "interactable"
			
			interactable_indicator.show()
		
		if Input.is_action_just_pressed("interact_or_grab"):
			interact(target, type)

func interact(target, type: String) -> void:
	match type:
		"grabbable": target.grab(self)
		"interactable": 
			target.interact(self)
			if target.has_ui:
				var ui: Control = target.ui_scene.instantiate()
				current_state = States.ON_UI
				interactables_ui.add_child(ui)

func _process(delta: float) -> void:
	if current_state == States.NORMAL:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if Input.is_action_just_pressed("exit"):
			get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	update_camera(delta)
	interact_cast()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && current_state == States.NORMAL:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
