@tool

extends HBoxContainer

@export var texture: Texture2D
@export var tag: String = ""
@export_multiline var evidence_name: String = "Name"
@export_multiline var evidence_description: String = "Description"


func _ready() -> void:
	update_inner_properties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_inner_properties()


func update_inner_properties() -> void:
	$Image/TextureRect.texture = texture
	$Name/RichTextLabel.text = evidence_name
	$Description/RichTextLabel.text = evidence_description
