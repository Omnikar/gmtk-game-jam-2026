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
	dt("cook", ["cook_character"], "cook_self_test")
]


func submit_evidence(character: String, tags: Array[String]) -> void:
	for trig in triggers:
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

		Dialogic.start(trig.timeline)
		return

	Dialogic.start("detective_unsure")
