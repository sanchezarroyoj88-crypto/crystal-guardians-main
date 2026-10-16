extends Node2D

@onready var crystal_label: Label = $UI/HUD/CrystalLabel

func _ready() -> void:
	QuestManager.quest_updated.connect(update_crystal_label)
	update_crystal_label()

func _on_crystal_collected() -> void:
	# El cristal ya validó y actualizó la misión antes de emitir la señal.
	update_crystal_label()

func update_crystal_label() -> void:
	var progress := "Crystals: %d / %d" % [
		QuestManager.collected_crystals, QuestManager.required_crystals
	]
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			crystal_label.text = progress + " — Talk to Han Solo (E)"
		QuestManager.QuestState.ACTIVE:
			crystal_label.text = progress + " — Quest active"
		QuestManager.QuestState.READY_TO_DELIVER:
			crystal_label.text = progress + " — Return to Han Solo (E)"
		QuestManager.QuestState.COMPLETED:
			crystal_label.text = progress + " — Quest completed"
