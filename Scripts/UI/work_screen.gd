extends PanelContainer

signal quest_accepted(quest: Quest)

@onready var quest_list: QuestList = %QuestList
@onready var client_grid_list: GridContainer = %ClientGridList

@export var list_item: PackedScene = preload("res://Scenes/UI/level_item.tscn")

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_easy_button_pressed() -> void:
	show_quest("easy")


func _on_moderate_button_pressed() -> void:
	show_quest("moderate")


func _on_hard_button_pressed() -> void:
	show_quest("hard")

func show_quest(diff: String) -> void:
	clear_list()
	var list: Array[Quest]
	match diff:
		"easy": list = quest_list.easy_quest
		"moderate": list = quest_list.moderate_quest
		"hard": list = quest_list.hard_quest
	for quest in list:
		var item_instance: LevelItem = list_item.instantiate()
		item_instance.client_accepted.connect(accept_button_pressed)
		client_grid_list.add_child(item_instance)
		item_instance.quest = quest
		item_instance.init_item()

func clear_list() -> void:
	for child in client_grid_list.get_children():
		child.queue_free()

func accept_button_pressed(quest: Quest) -> void:
	quest_accepted.emit(quest)
