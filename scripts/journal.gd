class_name Journal extends Control

signal evidence_presented(character: String, tags: Array[String])

@export var evidence_folder: String

var added_evidence: Dictionary[String, bool] = {}

var present_mode: bool = false
var present_target: String = ""
var selected_evidence: Dictionary[String, bool] = {}


func _ready() -> void:
	DialogueManager.journal = self

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_started.connect(hide)

	evidence_folder = evidence_folder.rstrip("/")

	add_evidence("cook_character")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_journal"):
		visible = !visible and Dialogic.current_timeline == null
		end_present_mode()


func _on_dialogic_signal(arg: Dictionary) -> void:
	var evidence_id = arg.get("add_evidence")
	var present_character = arg.get("present_evidence")

	if evidence_id != null and !added_evidence.has(evidence_id):
		add_evidence(evidence_id)
	elif present_character != null:
		present_target = present_character
		start_present_mode()


func add_evidence(evidence_id: String) -> void:
	var vbox = $TabContainer/Evidence/MarginContainer/VBoxContainer
	vbox.get_node("TutorialTip").hide()
	added_evidence[evidence_id] = true
	var scene_path = "%s/%s.tscn" % [evidence_folder, evidence_id]
	var scene_resource: PackedScene = load(scene_path)
	var scene_instance = scene_resource.instantiate()
	scene_instance.evidence_clicked.connect(_on_evidence_clicked)
	vbox.add_child(scene_instance)


func _on_evidence_clicked(tag: String) -> void:
	if present_mode:
		selected_evidence[tag] = !selected_evidence.get(tag, false)
		for entry in $TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
			if entry is EvidenceEntry and entry.tag == tag:
				entry.selected = selected_evidence[tag]
		var selected_count = 0
		for selected in selected_evidence.values():
			if selected:
				selected_count += 1
		var message = "%d items selected" % selected_count
		$SelectedCount.text = message
		$PresentButton.visible = selected_count >= 1


func start_present_mode() -> void:
	present_mode = true
	visible = true
	$SelectedCount.visible = true
	selected_evidence = {}


func end_present_mode() -> void:
	present_mode = false
	$SelectedCount.visible = false
	$PresentButton.visible = false
	for entry in $TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
		if entry is EvidenceEntry:
			entry.selected = false


func _on_present_button_pressed() -> void:
	end_present_mode()
	# evidence_presented.emit(present_target, Array(selected_evidence.keys()))
	DialogueManager.submit_evidence(present_target, Array(selected_evidence.keys()))
