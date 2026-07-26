extends Node


class DialogueTrigger:
	extends Resource
	var character: String
	var tags: Array[Array]
	var timeline: String
	var repeatable: bool

	func _init(ch: String, t: Array[Array], tl: String, rep: bool) -> void:
		character = ch
		tags = t
		timeline = tl
		repeatable = rep


func dt(ch: String, t: Array[Array], tl: String, rep: bool = false) -> DialogueTrigger:
	return DialogueTrigger.new(ch, t, tl, rep)


var triggers: Array[DialogueTrigger] = [
	# SYNTAX:
	# dt("current_character", [["evidence_tags", "list"], ["different", "tags_option"]], "dialogue_name"),
	#
	# Already-introduced
	dt("cook", [["cook_character"]], "detective_already_introduced"),
	dt("guard", [["guard_character"]], "detective_already_introduced"),
	dt("gardener", [["gardener_character"]], "detective_already_introduced"),
	dt("friend", [["friend_character"]], "detective_already_introduced"),
	dt("niece", [["niece_character"]], "detective_already_introduced"),
	#
	# --- COOK ---
	# Ask cook about other people
	dt("cook", [["guard_character"]], "cook_discuss_guard"),
	# Other
	dt("cook", [["friend_suspects_cook"]], "cook_friend_suspects"),
	dt("cook", [["garlic_suspicion"]], "cook_garlic_suspicion"),
	dt("cook", [["secret_cabinet"]], "cook_secret_cabinet"),
	#
	# --- GARDENER ---
	# Ask gardener about other people
	dt("gardener", [["cook_character"]], "gardener_discuss_cook"),
	dt("gardener", [["guard_character"]], "gardener_discuss_guard"),
	dt("gardener", [["niece_character"]], "gardener_discuss_niece"),
	dt("gardener", [["friend_character"]], "gardener_discuss_friend"),
	# Other
	dt("gardener", [["murder_weapon"]], "gardener_murder_weapon"),
	dt("gardener", [["vase"]], "gardener_vase"),
	dt("gardener", [["safe"]], "gardener_safe"),
	dt("gardener", [["garlic_suspicion"]], "gardener_garlic_suspicion"),
	dt("gardener", [["garlic_pouch"]], "gardener_garlic_found", true),
	dt("gardener", [["second_stake"]], "gardener_stake_found", true),
	dt("gardener", [["garlic_pouch", "second_stake"]], "gardener_garlic_stake_found"),
	dt("gardener", [["key", "key_location"]], "gardener_key_wrong"),
	dt("gardener", [["TODO"]], "gardener_broke_vase"),
	#
	# --- FRIEND ---
	# Ask friend about other people
	dt("friend", [["gardener_character"]], "friend_discuss_gardener"),
	dt("friend", [["guard_character"]], "friend_discuss_guard"),
	dt("friend", [["niece_character"]], "friend_discuss_niece"),
	dt("friend", [["cook_character"]], "friend_discuss_cook"),
	# Other
	dt("friend", [["reference_garlic"]], "friend_garlic_suspicion"),
	dt("friend", [["garlic_pouch"]], "friend_garlic_found"),
	dt("friend", [["vase"], ["broken_table"], ["vase", "broken_table"]], "friend_vase"),
	dt("friend", [["friend_vase_accusation"]], "friend_vase_accusation"),
	dt("friend", [["table_leg_supposedly_underneath", "broken_table"]], "friend_table_leg"),
	#
	# --- NIECE ---
	# Ask niece about other people
	dt("niece", [["gardener_character"]], "niece_discuss_gardener"),
	dt("niece", [["guard_character"]], "niece_discuss_guard"),
	dt("niece", [["friend_character"]], "niece_discuss_friend"),
	dt("niece", [["cook_character"]], "niece_discuss_cook"),
	# Other
	dt("niece", [["vase"], ["broken_table"], ["vase", "broken_table"]], "niece_vase"),
	dt("niece", [["TODO"]], "niece_will_accusation"),
	#
	# --- GUARD ---
	# Ask guard about other people
	dt("guard", [["cook_character"]], "guard_discuss_cook"),
	dt("guard", [["gardener_character"]], "guard_discuss_gardener"),
	dt("guard", [["niece_character"]], "guard_discuss_niece"),
	dt("guard", [["friend_character"]], "guard_discuss_friend"),
	# Other
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

		var found_match = false

		print(trig.tags)
		for trig_tags in trig.tags:
			print(tags)
			var tag_masks = {}
			for tag in trig_tags:
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
				print(trig_tags, " didn't work")
				continue
			found_match = true
			print(trig_tags, " worked")
			break

		if not found_match:
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
