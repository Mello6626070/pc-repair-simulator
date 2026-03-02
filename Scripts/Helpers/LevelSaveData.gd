class_name LevelSaveData extends Node

var id: String = ""
var played_num: int = 0
var top_score: float = 0
var finished: bool = false

func _init(quest_id: String) -> void:
	id = quest_id
