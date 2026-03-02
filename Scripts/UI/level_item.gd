class_name LevelItem extends PanelContainer

signal client_accepted(work: Quest)

@onready var client_id: Label = %ClientNumber
@onready var complaint_label: Label = %ComplaintLabel
@onready var status_label: Label = %StatusLabel
@onready var accept_button: Button = %AcceptButton
@onready var locked_panel: PanelContainer = %LockedPanel
@onready var times_played_label: Label = %TimesPlayedLabel
@onready var high_score_label: Label = %HighScoreLabel

enum DIFFICULTY{
	EASY,
	MEDIUM,
	HARD
}

var quest: Quest
var quest_saved_data: LevelSaveData
var status: String = "default"
var difficulty: DIFFICULTY = DIFFICULTY.EASY
var finished: bool
var index: int = 0

func init_item() -> void:
	SavedData.load_data()
	client_id.text = quest.quest_id
	complaint_label.text = quest.complaint
	print(difficulty)
	if quest.quest_id == "LEVEL 1":
		match difficulty:
			DIFFICULTY.EASY:
				if SavedData.easy_quest.size() == 0:
					var dictionary: Dictionary = {
						"id": "LEVEL 1",
						"played_num": 0,
						"highscore": 0.0,
						"finished": false
					}
					SavedData.add_level_data(dictionary, 0)
			DIFFICULTY.MEDIUM:
				if SavedData.medium_quest.size() == 0:
					var dictionary: Dictionary = {
						"id": "LEVEL 1",
						"played_num": 0,
						"highscore": 0.0,
						"finished": false
					}
					SavedData.add_level_data(dictionary, 1)
			DIFFICULTY.HARD:
				if SavedData.hard_quest.size() == 0:
					var dictionary: Dictionary = {
						"id": "LEVEL 1",
						"played_num": 0,
						"highscore": 0.0,
						"finished": false
					}
					SavedData.add_level_data(dictionary, 2)
		SavedData.save_data()
		locked_panel.hide()
	
	SavedData.load_data()
	match difficulty:
		DIFFICULTY.EASY:
			for data in SavedData.easy_quest:
				if data["id"] == quest.quest_id:
					times_played_label.text = "Attempts: " + str(int(data["played_num"]))
					high_score_label.text = "Highscore: " + str(data["highscore"])
					finished = data["finished"]
					
		DIFFICULTY.MEDIUM:
			for data in SavedData.medium_quest:
				if data["id"] == quest.quest_id:
					times_played_label.text = "Attempts: " + str(data["played_num"])
					high_score_label.text = "Highscore: " + str(data["highscore"])
					finished = data["finished"]

		DIFFICULTY.HARD:
			for data in SavedData.hard_quest:
				if data["id"] == quest.quest_id:
					times_played_label.text = "Attempts: " + str(data["played_num"])
					high_score_label.text = "Highscore: " + str(data["highscore"])
					finished = data["finished"]

	
	var parent = get_parent()
	if not quest.quest_id == "LEVEL 1":
		var siblings: Array = parent.get_children()
		if siblings[get_index() - 1].finished:
			locked_panel.hide()
	update_status()

func update_status() -> void:
		match status:
			"default":
				status_label.hide()
			"current":
				status_label.show()
				status_label.text = "Current"
			"finished":
				status_label.show()
				status_label.text = "Finished"

func _on_accept_button_pressed() -> void:
	client_accepted.emit(quest)
	var list: Array[LevelSaveData]
	status = "current"
	SavedData.load_data()
	
	var data_exist: bool
	
	match difficulty:
		DIFFICULTY.EASY:
			for data in SavedData.easy_quest:
				if data["id"] == quest.quest_id:
					data_exist = true
		DIFFICULTY.MEDIUM:
			for data in SavedData.medium_quest:
				if data["id"] == quest.quest_id:
					data_exist = true
		DIFFICULTY.HARD:
			for data in SavedData.hard_quest:
				if data["id"] == quest.quest_id:
					data_exist = true
	
	if data_exist:
		match difficulty:
			DIFFICULTY.EASY:
				for data in SavedData.easy_quest:
					if data["id"] == quest.quest_id:
						data["played_num"] = data["played_num"] + 1
			DIFFICULTY.MEDIUM:
				for data in SavedData.medium_quest:
					if data["id"] == quest.quest_id:
						data["played_num"] = data["played_num"] + 1
			DIFFICULTY.HARD:
				for data in SavedData.hard_quest:
					if data["id"] == quest.quest_id:
						data["played_num"] = data["played_num"] + 1
	else:
		match difficulty:
			DIFFICULTY.EASY:
				var data: Dictionary = {
					"id": quest.quest_id,
					"played_num": 1,
					"highscore": 0.0,
					"finished": false
				}
				SavedData.add_level_data(data, 0)
			DIFFICULTY.MEDIUM:
				var data: Dictionary = {
					"id": quest.quest_id,
					"played_num": 1,
					"highscore": 0.0,
					"finished": false
				}
				SavedData.add_level_data(data, 1)
			DIFFICULTY.HARD:
				var data: Dictionary = {
					"id": quest.quest_id,
					"played_num": 1,
					"highscore": 0.0,
					"finished": false
				}
				SavedData.add_level_data(data, 2)
	
	SavedData.save_data()
	update_status()
