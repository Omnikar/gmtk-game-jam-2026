@tool

extends Control

@export var texture: Texture2D
@export var tag: String = ""
@export_multiline var evidence_name: String = "Name"
@export_multiline var evidence_description: String = "Description"


func _ready() -> void:
	update_inner_properties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_inner_properties()


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		print(name)


func update_inner_properties() -> void:
	$HBoxContainer/Image/TextureRect.texture = texture
	$HBoxContainer/Name/RichTextLabel.text = evidence_name
	$HBoxContainer/Description/RichTextLabel.text = evidence_description
