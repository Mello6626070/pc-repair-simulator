extends PanelContainer

signal quest_accepted(quest: Quest)

@onready var quest_list: QuestList = %QuestList
@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var easy_list: VBoxContainer = %EasyList
@onready var medium_list: VBoxContainer = %MediumList
@onready var hard_list: VBoxContainer = %HardList

@export var list_item: PackedScene = preload("res://Scenes/UI/level_item.tscn")

func _ready() -> void:
	show_quest()

func _process(delta: float) -> void:
	pass

func show_quest() -> void:
	for quest in quest_list.easy_quest:
		var item: LevelItem = list_item.instantiate()
		easy_list.add_child(item)
		item.quest = quest
		item.init_item()
		item.client_accepted.connect(accept_button_pressed)
	
	for quest in quest_list.moderate_quest:
		var item: LevelItem = list_item.instantiate()
		medium_list.add_child(item)
		item.quest = quest
		item.init_item()
		item.client_accepted.connect(accept_button_pressed)
	
	for quest in quest_list.hard_quest:
		var item: LevelItem = list_item.instantiate()
		hard_list.add_child(item)
		item.quest = quest
		item.init_item()
		item.client_accepted.connect(accept_button_pressed)

func accept_button_pressed(quest: Quest) -> void:
	button_sfx.play()
	quest_accepted.emit(quest)
