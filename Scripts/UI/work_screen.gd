extends PanelContainer

signal quest_accepted(quest: Quest)

@onready var quest_list: QuestList = %QuestList
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var easy_list: HBoxContainer = %EasyList
@onready var medium_list: HBoxContainer = %MediumList
@onready var hard_list: HBoxContainer = %HardList
@onready var lock_panel_medium: PanelContainer = %LockPanelMedium
@onready var lock_panel_hard: PanelContainer = %LockPanelHard


@export var list_item: PackedScene = preload("res://Scenes/UI/level_item.tscn")

func _ready() -> void:
	show_quest()

func _process(delta: float) -> void:
	pass

func show_quest() -> void:
	SavedData.load_data()
	var i: int = 0
	for quest in quest_list.easy_quest:
		var item: LevelItem = list_item.instantiate()
		easy_list.add_child(item)
		item.difficulty = item.DIFFICULTY.EASY
		item.quest = quest
		item.index = i
		print(i)
		i += 1
		item.init_item()
		item.client_accepted.connect(accept_button_pressed)
	
	if easy_list.get_children()[9].finished:
		lock_panel_medium.hide()
		var j: int = 0
		for quest in quest_list.moderate_quest:
			var item: LevelItem = list_item.instantiate()
			medium_list.add_child(item)
			item.quest = quest
			item.difficulty = item.DIFFICULTY.MEDIUM
			item.index = j
			print(j)
			j += 1
			item.init_item()
			item.client_accepted.connect(accept_button_pressed)
	
	if medium_list.get_child_count() >= 10:
		if easy_list.get_children()[9].finished:
			lock_panel_medium.hide()
			var k: int = 0
			for quest in quest_list.hard_quest:
				var item: LevelItem = list_item.instantiate()
				hard_list.add_child(item)
				item.quest = quest
				item.difficulty = item.DIFFICULTY.HARD
				item.index = k
				print(k)
				k += 1
				item.init_item()
				item.client_accepted.connect(accept_button_pressed)

func accept_button_pressed(quest: Quest) -> void:
	button_sfx.play()
	quest_accepted.emit(quest)
