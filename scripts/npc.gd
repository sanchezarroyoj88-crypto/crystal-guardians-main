extends Node2D

@onready var interactive_area: Area2D = $InteractiveArea
var player_nearby: bool = false

func _ready() -> void:
	# Las dos señales ya están conectadas en npc.tscn.
	$AnimatedSprite2D.play("idle")

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")
		if dialogue_ui.is_open():
			dialogue_ui.next_dialogue()
		else:
			interact()

func interact() -> void:
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")
	if dialogue_ui.is_open():
		return
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			dialogue_ui.show_dialogue("Han Solo", [
				"I need your help! The guards are protecting the crystals.",
				"Collect %d crystals and return to me to deliver them." % QuestManager.required_crystals,
				"Quest started: you can now collect the crystals."
			])
			QuestManager.start_quest()
		QuestManager.QuestState.ACTIVE:
			dialogue_ui.show_dialogue("Han Solo", [
				"You have %d of %d crystals. Keep looking!" % [QuestManager.collected_crystals, QuestManager.required_crystals]
			])
		QuestManager.QuestState.READY_TO_DELIVER:
			dialogue_ui.show_dialogue("Han Solo", [
				"You found all the crystals! Thank you for bringing them back.",
				"Quest completed. The crystals are safe!"
			])
			QuestManager.complete_quest()
		QuestManager.QuestState.COMPLETED:
			dialogue_ui.show_dialogue("Han Solo", ["Thank you for your help. You have already completed the quest."])

func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		get_tree().current_scene.get_node("DialogueUI").close_dialogue()
