extends PanelContainer

@onready var quest_list: QuestList = %QuestList
@onready var client_grid_list: GridContainer = %ClientGridList

@export var list_item: PackedScene

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_easy_button_pressed() -> void:
	show_easy_quest()


func _on_moderate_button_pressed() -> void:
	pass # Replace with function body.


func _on_hard_button_pressed() -> void:
	pass # Replace with function body.

func show_easy_quest() -> void:
	clear_list()
	var list: Array[Quest] = quest_list.easy_quest
	for quest in list:
		pass

func clear_list() -> void:
	for child in client_grid_list.get_children():
		child.queue_free()

func instanciate_list_item(quest: Quest) -> void:
	pass
