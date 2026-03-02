class_name Player extends CharacterBody3D
signal post_selected_quest(quest: Quest)
signal post_quest_finished()
signal timer_timeout()

@export_category("Camera Stuff")
@export var mouse_sens: float = 0.5
@export var MAX_TILT: float = deg_to_rad(90)
@export var MIN_TILT: float = deg_to_rad(-90)

@export_category("Player Movemenent")
@export var SPEED: float = 5.0

@export var target: Node3D
@onready var camera_container: Node3D = $CameraContainer
@onready var interaction_ray_cast: RayCast3D = $CameraContainer/InteractionRayCast
@onready var interactable_indicator: Label = $HUD/InteractableIndicator
@onready var interactables_ui: CanvasLayer = %InteractablesUI
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $HUD/TimerLabel
@onready var task_label: Label = %TaskLabel
@onready var task_panel: PanelContainer = %TaskPanel
@onready var panel: Panel = %Panel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var move_hint: CenterContainer = $HUD/Hints/MoveHint
@onready var how_to_play_hint: CenterContainer = $HUD/Hints/HowToPlayHint
@onready var hints: Control = $HUD/Hints
@onready var timer_timeout_warning: CanvasLayer = %TimerTimeoutWarning
@onready var lost_sfx: AudioStreamPlayer = $LostSFX
@onready var pointer: Node3D = %Pointer


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
var target_pc: Computer
var quest_finished: bool
var quest_selected: bool
var quest_working: bool
var time: int
var timer_value: int
var walking: bool = false

func _ready() -> void:
	panel.show()
	move_hint.show()
	current_state = States.ON_UI
	animation_player.play("fade_out")
	await animation_player.animation_finished
	panel.hide()
	print("mouse captured")

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
				interactable_indicator.text = "Press E to interact"
				type = "grabbable"
			elif target.has_method("interact"):
				interactable_indicator.text = "Press E to interact"
				type = "interactable"
			
			interactable_indicator.show()
		
		if Input.is_action_just_pressed("interact_or_grab"):
			interact(target, type)

func interact(target, type: String) -> void:
	match type:
		"grabbable": 
			target.grab(self)
			print("grabbed")
		"interactable": 
			target.interact(self)
			if target.has_ui:
				var ui: Control = target.ui_scene.instantiate()
				current_state = States.ON_UI
				interactables_ui.add_child(ui)
				quest_working = true
				print(target_pc)

func _input(event: InputEvent) -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		panel.show()
		animation_player.play_backwards("fade_out")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu_3d.tscn")
	if current_state == States.NORMAL:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	timer_label.text = str(int(timer.time_left))
	timer_value = int(timer.time_left)
	
	if quest_selected and not quest_working:
		pointer.show()
		pointer.look_at(target.global_transform.origin, Vector3.UP)
	else:
		pointer.hide()

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
		if !walking:
			walking = true
			audio_stream_player.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if walking:
			walking = false
			audio_stream_player.stop()
	move_and_slide()

func quest_select(quest: Quest) -> void:
	quest_selected = true
	time = quest.time
	post_selected_quest.emit(quest)
	task_panel.show()
	var text: String = quest.explaination
	task_label.text = text
	print(quest.explaination)

func start_timer() -> void:
	timer_label.show()
	timer.start(time)

func stop_timer() -> void:
	timer_label.hide()
	timer.stop()

func _on_timer_timeout() -> void:
	timer_label.self_modulate = Color.RED
	timer_timeout_warning.show()
	timer.stop()
	lost_sfx.play()
	task_panel.hide()
	current_state = States.ON_UI

func _on_post_quest_finished() -> void:
	task_panel.hide()

func _on_exit_button_pressed() -> void:
	panel.show()
	animation_player.play_backwards("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_audio_stream_player_finished() -> void:
	if walking:
		audio_stream_player.play(0.8)


func _on_how_to_play_ok_button_pressed() -> void:
	hints.hide()
	current_state = States.NORMAL


func _on_how_to_move_ok_button_pressed() -> void:
	move_hint.hide()
	how_to_play_hint.show()

func minus_time() -> void:
	if timer.time_left > 0:
		var time: float = timer.time_left
		timer.stop()
		time -= 10.0
		if time <= 0:
			time = 0
		timer.start(time)

func _on_time_out_ok_button_pressed() -> void:
	timer_label.hide()
	panel.show()
	animation_player.play_backwards("fade_out")
	await animation_player.animation_finished
	if interactables_ui.get_child_count() > 0:
		for child in interactables_ui.get_children():
			child.queue_free()
	timer_timeout_warning.hide()
	timer_timeout.emit()
	animation_player.play("fade_out")
	await  animation_player.animation_finished
	panel.hide()
	current_state = States.NORMAL
