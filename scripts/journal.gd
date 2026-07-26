extends CanvasLayer

@export var evidence_folder: String
@export var transcript_folder: String
@export var transcript_entry_prefab_file: String

var added_evidence: Dictionary[String, bool] = {}

var present_mode: bool = false
var present_target: String = ""
var selected_evidence: Dictionary[String, bool] = {}

# This isn't actually a property of Journal but it's a singleton so I'm exploiting it
var player_can_interact: Dictionary[int, bool] = {}


func _ready() -> void:
	visible = false
	$Control/PresentButton.visible = false

	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_started.connect(_on_timeline_started)

	evidence_folder = evidence_folder.rstrip("/")
	transcript_folder = transcript_folder.rstrip("/")

	for entry in $Control/TabContainer/Reference/MarginContainer/VBoxContainer.get_children():
		if entry is TranscriptEntry:
			entry.transcript_clicked.connect(_on_evidence_clicked)

	add_evidence("gardener_character")
	add_evidence("cook_character")
	add_evidence("niece_character")
	add_evidence("friend_character")
	add_evidence("guard_character")


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
		Dialogic.end_timeline(true)
		if present_character != "":
			present_target = present_character
		start_present_mode()


func add_evidence(evidence_id: String) -> void:
	var vbox = $Control/TabContainer/Evidence/MarginContainer/VBoxContainer
	vbox.get_node("TutorialTip").hide()
	added_evidence[evidence_id] = true
	var scene_path = "%s/%s.tscn" % [evidence_folder, evidence_id]
	var scene_resource: PackedScene = load(scene_path)
	var scene_instance = scene_resource.instantiate()
	scene_instance.evidence_clicked.connect(_on_evidence_clicked)
	vbox.add_child(scene_instance)
	vbox.move_child(scene_instance, 0)


func add_transcript(transcript_id: String) -> void:
	var transcript_path = "%s/%s.txt" % [transcript_folder, transcript_id]
	var file = FileAccess.open(transcript_path, FileAccess.READ)
	if file == null:
		return
	var content = file.get_as_text()

	var entries = content.split("\n\n\n")
	for entry: String in entries:
		entry = entry.strip_edges()
		var tag: String = ""
		if entry[0] == "{":
			var splits = entry.substr(1).split("}")
			tag = splits[0]
			entry = splits[1]

		var parts = entry.split("---")
		var prompt = parts[0].strip_edges()
		var response = parts[1].strip_edges() if len(parts) >= 2 else ""

		var scene_resource: PackedScene = load(transcript_entry_prefab_file)
		var scene_instance: TranscriptEntry = scene_resource.instantiate()
		scene_instance.transcript_clicked.connect(_on_evidence_clicked)
		scene_instance.tag = tag
		scene_instance.prompt = prompt
		scene_instance.response = response

		var character_name: String = transcript_id.split("_", 1)[0]
		var tab = $Control/TabContainer/Transcripts.get_node_or_null(character_name)
		if not tab:
			return
		var vbox = tab.get_node("VBoxContainer")
		vbox.add_child(scene_instance)


func _on_timeline_started() -> void:
	visible = false

	if Dialogic.current_timeline == null:
		return

	var timeline_path: String = Dialogic.current_timeline.resource_path
	var timeline_name: String = timeline_path.get_file().split(".", 1)[0]
	add_transcript(timeline_name)


func _on_evidence_clicked(tag: String) -> void:
	if present_mode:
		selected_evidence[tag] = !selected_evidence.get(tag, false)
		for entry in $Control/TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
			if entry is EvidenceEntry and entry.tag == tag:
				entry.selected = selected_evidence[tag]
		for tab in $Control/TabContainer/Transcripts.get_children():
			for entry in tab.get_node("VBoxContainer").get_children():
				if entry is TranscriptEntry and entry.tag == tag:
					entry.selected = selected_evidence[tag]
		for entry in $Control/TabContainer/Reference/MarginContainer/VBoxContainer.get_children():
			if entry is TranscriptEntry and entry.tag == tag:
				entry.selected = selected_evidence[tag]
		var selected_count = 0
		for selected in selected_evidence.values():
			if selected:
				selected_count += 1
		var s = "" if selected_count == 1 else "s"
		var message = "%d item%s selected" % [selected_count, s]
		$Control/SelectedCount.text = message
		$Control/PresentButton.visible = selected_count >= 1


func start_present_mode() -> void:
	present_mode = true
	visible = true
	$Control/SelectedCount.visible = true
	selected_evidence = {}


func end_present_mode() -> void:
	present_mode = false
	$Control/SelectedCount.text = "0 items selected"
	$Control/SelectedCount.visible = false
	$Control/PresentButton.visible = false
	for entry in $Control/TabContainer/Evidence/MarginContainer/VBoxContainer.get_children():
		if entry is EvidenceEntry:
			entry.selected = false
	for tab in $Control/TabContainer/Transcripts.get_children():
		for entry in tab.get_node("VBoxContainer").get_children():
			if entry is TranscriptEntry:
				entry.selected = false
	for entry in $Control/TabContainer/Reference/MarginContainer/VBoxContainer.get_children():
		if entry is TranscriptEntry:
			entry.selected = false


func _on_present_button_pressed() -> void:
	end_present_mode()
	# evidence_presented.emit(present_target, Array(selected_evidence.keys()))
	DialogueManager.submit_evidence(present_target, Array(selected_evidence.keys()))
