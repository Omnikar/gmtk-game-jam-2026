@tool

extends VBoxContainer

@export_multiline var prompt: String = "Prompt"
@export_multiline var response: String = "Response"


func _ready() -> void:
	update_inner_properties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_inner_properties()


func update_inner_properties() -> void:
	$Prompt/Text.text = prompt
	$Response/Text.text = response
