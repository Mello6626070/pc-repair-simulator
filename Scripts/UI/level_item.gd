extends PanelContainer

signal client_accepted()

@onready var client_id: Label = %ClientNumber
@onready var complaint_label: Label = %ComplaintLabel
@onready var status_label: Label = %StatusLabel
@onready var accept_button: Button = %AcceptButton

var quest: Quest

func init_item() -> void:
	client_id.text = quest.quest_id
	complaint_label.text = quest.complaint

func _on_accept_button_pressed() -> void:
	pass # Replace with function body.
