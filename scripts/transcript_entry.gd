@tool

class_name TranscriptEntry extends Control

signal transcript_clicked(tag: String)

@export var tag: String = ""
@export_multiline var prompt: String = "Prompt"
@export_multiline var response: String = "Response"

@export var highlight_override: bool = false

var significant: bool = true
var selected: bool = false


func _ready() -> void:
	selected = false
	update_inner_properties()
	if not Engine.is_editor_hint() and tag.is_empty():
		tag = str(randi())
		significant = false


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update_inner_properties()
	else:
		$Selected.visible = selected


func _gui_input(event: InputEvent) -> void:
	if (
		significant
		and event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		transcript_clicked.emit(tag)


func update_inner_properties() -> void:
	$VBoxContainer/Prompt/Text.text = prompt
	$VBoxContainer/Response/Text.text = response

	# if response.is_empty():
	# 	$Selected.size_flags_horizontal = SizeFlags.SIZE_SHRINK_END
	# else:
	# 	$Selected.size_flags_horizontal = SizeFlags.SIZE_SHRINK_BEGIN
	if len(prompt) > len(response):
		$Selected.size_flags_horizontal = SizeFlags.SIZE_SHRINK_END
	else:
		$Selected.size_flags_horizontal = SizeFlags.SIZE_SHRINK_BEGIN

	if not tag.is_empty() and not highlight_override:
		modulate = Color.hex(0xfb7e43ff)
	else:
		modulate = Color.WHITE
