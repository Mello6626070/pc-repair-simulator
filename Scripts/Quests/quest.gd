class_name Quest extends Resource
@export var quest_id: String
@export_multiline var complaint: String
@export_multiline var explaination: String
@export var initial_conditions: Array[ComponentType] = []
@export var winning_conditions: Array[ComponentType] = []
@export var time: float
@export var finished: bool = false
@export var attempts: int = 0
@export var highscore: float = 0.0
@export_range(0, 2) var difficulty: int = 0
