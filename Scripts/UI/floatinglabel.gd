class_name FloatingLabel extends Label3D

@onready var timer: Timer = $Timer

var float_speed: float = 0.02
var time: float = 10
var string: String = ""

enum TYPE{
	GOOD,
	BAD
}

var type: TYPE

func _ready() -> void:
	text = string
	match type:
		TYPE.GOOD:
			modulate = Color.GREEN
		TYPE.BAD:
			modulate = Color.RED

func _process(delta: float) -> void:
	position.y += float_speed

func _on_timer_timeout() -> void:
	queue_free()
