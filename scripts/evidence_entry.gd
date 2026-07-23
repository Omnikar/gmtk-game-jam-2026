@tool

extends HBoxContainer

@export var texture: Texture2D
@export_multiline var evidence_name: String = "Name"
@export_multiline var evidence_description: String = "Description"


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$Image/TextureRect.texture = texture
		$Name/RichTextLabel.text = evidence_name
		$Description/RichTextLabel.text = evidence_description
