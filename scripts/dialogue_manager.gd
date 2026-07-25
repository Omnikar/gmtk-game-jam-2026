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
	#
	dt("cook", ["cook_character"], "detective_already_introduced"),
	dt("cook", ["guard_character"], "cook_discuss_guard"),
]

var used_triggers: Array[int] = []


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
