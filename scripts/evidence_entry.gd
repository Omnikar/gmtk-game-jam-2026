@tool

class_name EvidenceEntry extends Control

signal evidence_clicked(tag: String)

@export var texture: AtlasTexture
@export var tag: String = ""
@export_multiline var evidence_name: String = "Name"
@export_multiline var evidence_description: String = "Description"

var selected: bool = false


func _ready() -> void:
	update_inner_properties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_inner_properties()
	else:
		$Selected.visible = selected


func _gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		evidence_clicked.emit(tag)


func update_inner_properties() -> void:
	$HBoxContainer/Image/TextureRect.texture = texture
	$HBoxContainer/Name/RichTextLabel.text = evidence_name
	$HBoxContainer/Description/RichTextLabel.text = evidence_description
