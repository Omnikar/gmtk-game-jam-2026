extends Control

@export var evidence_folder: String

var added_evidence: Dictionary[String, bool] = {}

var present_mode: bool = false
var selected_evidence: Dictionary[String, bool] = {}


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_started.connect(hide)

	evidence_folder = evidence_folder.rstrip("/")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_journal"):
		visible = !visible and Dialogic.current_timeline == null
		end_present_mode()


func _on_dialogic_signal(arg: Dictionary) -> void:
	var evidence_id = arg.get("add_evidence")
	var present_character = arg.get("present_evidence")

	if evidence_id != null and !added_evidence.has(evidence_id):
		var vbox = $TabContainer/Evidence/MarginContainer/VBoxContainer
		vbox.get_node("TutorialTip").hide()
		added_evidence[evidence_id] = true
		var scene_path = "%s/%s.tscn" % [evidence_folder, evidence_id]
		var scene_resource: PackedScene = load(scene_path)
		var scene_instance = scene_resource.instantiate()
		scene_instance.evidence_clicked.connect(_on_evidence_clicked)
		vbox.add_child(scene_instance)
	elif present_character != null:
		start_present_mode()


func _on_evidence_clicked(tag: String) -> void:
	if present_mode:
		selected_evidence[tag] = !selected_evidence.get(tag, false)
		for entry in $TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
			if entry is EvidenceEntry and entry.tag == tag:
				entry.selected = selected_evidence[tag]


func start_present_mode() -> void:
	present_mode = true
	visible = true
	selected_evidence = {}


func end_present_mode() -> void:
	present_mode = false
	for entry in $TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
		if entry is EvidenceEntry:
			entry.selected = false
