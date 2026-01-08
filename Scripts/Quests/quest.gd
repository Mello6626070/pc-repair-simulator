class_name Quest extends Resource
@export var quest_id: String
@export_multiline var complaint: String
@export_multiline var explaination: String
@export var initial_conditions: Array[ComponentType] = []
@export var winning_conditions: Array[ComponentType] = []
@export var reward: float = 100.0
