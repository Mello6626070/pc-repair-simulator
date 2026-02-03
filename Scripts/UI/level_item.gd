class_name LevelItem extends PanelContainer

signal client_accepted(work: Quest)

@onready var client_id: Label = %ClientNumber
@onready var complaint_label: Label = %ComplaintLabel
@onready var status_label: Label = %StatusLabel
@onready var accept_button: Button = %AcceptButton

var quest: Quest
var status: String = "default"

func init_item() -> void:
	client_id.text = quest.quest_id
	complaint_label.text = quest.complaint
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
	status = "current"
	update_status()
