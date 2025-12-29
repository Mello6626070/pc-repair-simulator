class_name Quest extends Resource
@export var quest_id: String
@export var complaint: String
@export var explaination: String
@export var initial_conditions: Array[QuestCondition]
@export var winning_conditions: Array[QuestCondition]
@export var reward: float
