extends CharacterBody3D

@export_category("Camera Stuff")
@export var mouse_sens: float = 0.5
@export var MAX_TILT: float = deg_to_rad(90)
@export var MIN_TILT: float = deg_to_rad(-90)

@export_category("Player Movemenent")
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5

@onready var camera_container: Node3D = $CameraContainer
@onready var interaction_ray_cast: RayCast3D = $CameraContainer/InteractionRayCast

var mouse_input: bool = false
var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var player_rotation: Vector3
var camera_rotation: Vector3

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion && Input.mouse_mode
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

func _physics_process(delta: float) -> void:
	update_camera(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if interaction_ray_cast.is_colliding():
		var target = interaction_ray_cast.get_collider()
		print(target)
	move_and_slide()
