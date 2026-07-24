extends Control

@export var evidence_folder: String

var added_evidence: Dictionary[String, bool] = {}


func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_started.connect(hide)

	evidence_folder = evidence_folder.rstrip("/")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_journal"):
		visible = !visible and Dialogic.current_timeline == null


func _on_dialogic_signal(arg: Dictionary) -> void:
	var evidence_id = arg.get("add_evidence")
	var vbox = $TabContainer/Evidence/MarginContainer/VBoxContainer
	vbox.get_node("TutorialTip").hide()
	if evidence_id != null and !added_evidence.has(evidence_id):
		added_evidence[evidence_id] = true
		var scene_path = "%s/%s.tscn" % [evidence_folder, evidence_id]
		var scene_resource: PackedScene = load(scene_path)
		var scene_instance = scene_resource.instantiate()
		vbox.add_child(scene_instance)
