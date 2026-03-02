extends Node

const FILE_PATH: String = "user://savedata.json"
const KEY: String = "qawsedrftgyhujikol"

@export var easy_quest: Array = []
@export var medium_quest: Array = []
@export var hard_quest: Array = []

func save_data() -> void:
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	
	var data: Dictionary = {
		"easy_quest": easy_quest,
		"medium_quest": medium_quest,
		"hard_quest": hard_quest
	}
	var json: String = JSON.stringify(data, "\t")
	file.store_string(json)
	file.close()

func load_data() -> void:
	if FileAccess.file_exists(FILE_PATH):
		var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
		var json: String = file.get_as_text()
		var data: Dictionary = JSON.parse_string(json)
		easy_quest = data["easy_quest"]
		medium_quest = data["medium_quest"]
		hard_quest = data["hard_quest"]
		
		file.close()

func reset_data() -> void:
	easy_quest = []
	medium_quest = []
	hard_quest = []
	save_data()

func add_level_data(data: Dictionary, difficulty: int) -> void:
	match difficulty:
		0: easy_quest.append(data)
		1: medium_quest.append(data)
		2: hard_quest.append(data)
