extends Node


class DialogueTrigger:
	extends Resource
	var character: String
	var tags: Array[String]
	var timeline: String
	var repeatable: bool

	func _init(ch: String, t: Array[String], tl: String, rep: bool) -> void:
		character = ch
		tags = t
		timeline = tl
		repeatable = rep


func dt(ch: String, t: Array[String], tl: String, rep: bool = false) -> DialogueTrigger:
	return DialogueTrigger.new(ch, t, tl, rep)


var triggers: Array[DialogueTrigger] = [
	# SYNTAX:
	# dt("current_character", ["list", "of", "evidence_tags"], "dialogue_name"),
	#
	# Already-introduced
	dt("cook", ["cook_character"], "detective_already_introduced"),
	dt("guard", ["guard_character"], "detective_already_introduced"),
	dt("gardener", ["gardener_character"], "detective_already_introduced"),
	dt("friend", ["friend_character"], "detective_already_introduced"),
	dt("niece", ["niece_character"], "detective_already_introduced"),
	#
	# --- COOK ---
	# Ask cook about other people
	dt("cook", ["guard_character"], "cook_discuss_guard"),
	dt("cook", ["friend_suspects_cook"], "cook_friend_suspects"),
	#
	# --- GARDENER ---
	# Ask gardener about other people
	dt("gardener", ["cook_character"], "gardener_discuss_cook"),
	dt("gardener", ["guard_character"], "gardener_discuss_guard"),
	dt("gardener", ["niece_character"], "gardener_discuss_niece"),
	dt("gardener", ["friend_character"], "gardener_discuss_friend"),
	# Other
	dt("gardener", ["murder_weapon"], "gardener_murder_weapon"),
	dt("gardener", ["vase"], "gardener_vase"),
	dt("gardener", ["safe"], "gardener_safe"),
	dt("gardener", ["TODO"], "gardener_garlic_suspicion"),
	dt("gardener", ["garlic_pouch"], "gardener_garlic_found", true),
	dt("gardener", ["second_stake"], "gardener_stake_found", true),
	dt("gardener", ["garlic_pouch", "second_stake"], "gardener_garlic_stake_found"),
	dt("gardener", ["key", "key_location"], "gardener_key_wrong"),
	dt("gardener", ["TODO"], "gardener_broke_vase"),
	#
	# --- FRIEND ---
	# Ask friend about other people
	dt("friend", ["gardener_character"], "friend_discuss_gardener"),
	dt("friend", ["guard_character"], "friend_discuss_guard"),
	dt("friend", ["niece_character"], "friend_discuss_niece"),
	dt("friend", ["cook_character"], "friend_discuss_cook"),
	# Other
	#
	# --- NIECE ---
	# Ask niece about other people
	#
	# --- GUARD ---
	# Ask guard about other people
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
			if Dialogic.current_timeline == null:
				Dialogic.start("detective_already_asked")
		else:
			if Dialogic.current_timeline == null:
				Dialogic.start(trig.timeline)
			if not trig.repeatable:
				used_triggers.append(i)
		return

	if Dialogic.current_timeline == null:
		Dialogic.start("detective_unsure")
