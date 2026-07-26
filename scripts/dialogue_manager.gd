extends Node


class DialogueTrigger:
	extends Resource
	var character: String
	var tags: Array[String]
	var timeline: String

	func _init(ch: String, t: Array[String], tl: String) -> void:
		character = ch
		tags = t
		timeline = tl


func dt(ch: String, t: Array[String], tl: String) -> DialogueTrigger:
	return DialogueTrigger.new(ch, t, tl)


var triggers: Array[DialogueTrigger] = [
	# Already-introduced
	dt("cook", ["cook_character"], "detective_already_introduced"),
	dt("guard", ["guard_character"], "detective_already_introduced"),
	dt("gardener", ["gardener_character"], "detective_already_introduced"),
	dt("friend", ["friend_character"], "detective_already_introduced"),
	dt("niece", ["niece_character"], "detective_already_introduced"),
	# Ask cook about other people
	dt("cook", ["guard_character"], "cook_discuss_guard"),
	# Ask gardener about other people
	dt("gardener", ["cook_character"], "gardener_discuss_cook"),
	dt("gardener", ["guard_character"], "gardener_discuss_guard"),
]

var used_triggers: Array[int] = []


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_end_dialogue") and Dialogic.current_timeline != null:
		Dialogic.end_timeline(true)


func submit_evidence(character: String, tags: Array[String]) -> void:
	var i: int = -1
	for trig in triggers:
		i += 1
		if trig.character != character:
			continue
		var tag_masks = {}
		for tag in trig.tags:
			tag_masks[tag] = 1
		for tag in tags:
			var truncated = tag.split("-", 1)[0]
			tag_masks.get_or_add(truncated, 0)
			tag_masks[truncated] |= 2
		var matches = true
		for mask in tag_masks.values():
			if mask != 3:
				matches = false
		if not matches:
			continue

		if i in used_triggers:
			Dialogic.start("detective_already_asked")
		else:
			Dialogic.start(trig.timeline)
			used_triggers.append(i)
		return

	Dialogic.start("detective_unsure")
