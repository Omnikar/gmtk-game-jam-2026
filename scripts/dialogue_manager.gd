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
	dt("cook", [["cook_character"]], "detective_already_introduced", true),
	dt("guard", [["guard_character"]], "detective_already_introduced", true),
	dt("gardener", [["gardener_character"]], "detective_already_introduced", true),
	dt("friend", [["friend_character"]], "detective_already_introduced", true),
	dt("niece", [["niece_character"]], "detective_already_introduced", true),
	#
	# --- COOK ---
	# Ask cook about other people
	dt("cook", [["guard_character"]], "cook_discuss_guard"),
	dt("cook", [["niece_character"]], "cook_discuss_niece"),
	dt("cook", [["friend_character"]], "cook_discuss_friend"),
	dt("cook", [["gardener_character"]], "cook_discuss_gardener"),
	# Other
	dt("cook", [["murder_weapon"]], "cook_murder_weapon"),
	dt("cook", [["safe"]], "cook_safe"),
	dt("cook", [["friend_suspects_cook"]], "cook_friend_suspects"),
	dt("cook", [["garlic_suspicion"]], "cook_garlic_suspicion"),
	dt("cook", [["secret_cabinet"]], "cook_secret_cabinet"),
	dt("cook", [["key", "key_location"]], "cook_key_wrong"),
	dt(
		"cook",
		[["garlic_pouch"], ["second_stake"], ["garlic_pouch", "second_stake"]],
		"cook_garlic_accusation",
	),
	dt(
		"cook",
		[
			["vase"],
			["broken_table"],
			["vase", "broken_table"],
			["someone_in_hallway"],
			["cook_vase_alibi"],
		],
		"cook_vase"
	),
	dt("cook", [["someone_in_hallway", "guard_is_vampire"]], "detective_need_to_clear_cook", true),
	#
	# --- GARDENER ---
	# Ask gardener about other people
	dt("gardener", [["cook_character"]], "gardener_discuss_cook"),
	dt("gardener", [["guard_character"]], "gardener_discuss_guard"),
	dt("gardener", [["niece_character"]], "gardener_discuss_niece"),
	dt("gardener", [["friend_character"]], "gardener_discuss_friend"),
	# Other
	dt("gardener", [["murder_weapon"]], "gardener_murder_weapon"),
	dt("gardener", [["vase"], ["broken_table"], ["vase", "broken_table"]], "gardener_vase"),
	dt("gardener", [["safe"]], "gardener_safe"),
	dt("gardener", [["garlic_suspicion"]], "gardener_garlic_suspicion"),
	dt("gardener", [["garlic_pouch"]], "gardener_garlic_found", true),
	dt("gardener", [["second_stake"]], "gardener_stake_found", true),
	dt("gardener", [["garlic_pouch", "second_stake"]], "gardener_garlic_stake_found"),
	dt("gardener", [["key"]], "gardener_key", true),
	dt("gardener", [["key", "key_location"]], "gardener_key_wrong"),
	dt("gardener", [["guard_is_vampire"]], "gardener_guard_vampire"),
	dt(
		"gardener",
		[["someone_in_hallway", "cook_vase_alibi", "guard_is_vampire"]],
		"gardener_broke_vase",
	),
	dt(
		"gardener",
		[["someone_in_hallway", "cook_vase_alibi"]],
		"detective_need_to_clear_guard",
		true
	),
	dt(
		"gardener",
		[["someone_in_hallway", "guard_is_vampire"]],
		"detective_need_to_clear_cook",
		true
	),
	dt("gardener", [["niece_bribed_cook", "gardener_is_thief"]], "gardener_final_accusation"),
	#
	# --- FRIEND ---
	# Ask friend about other people
	dt("friend", [["gardener_character"]], "friend_discuss_gardener"),
	dt("friend", [["guard_character"]], "friend_discuss_guard"),
	dt("friend", [["niece_character"]], "friend_discuss_niece"),
	dt("friend", [["cook_character"]], "friend_discuss_cook"),
	# Other
	dt("friend", [["murder_weapon"]], "friend_murder_weapon", true),
	dt(
		"friend",
		[["reference_garlic"], ["reference_garlic", "friend_suspects_cook"]],
		"friend_garlic_suspicion"
	),
	dt("friend", [["garlic_pouch"]], "friend_garlic_found"),
	dt("friend", [["vase"], ["broken_table"], ["vase", "broken_table"]], "friend_vase"),
	dt("friend", [["friend_vase_accusation"]], "friend_vase_accusation"),
	dt("friend", [["table_leg_supposedly_underneath", "broken_table"]], "friend_table_leg"),
	dt(
		"friend",
		[
			["guard_is_vampire", "fake_will"],
			["guard_stayed_outside", "guard_is_vampire", "fake_will"],
			["guard_is_vampire", "fake_will", "reference_entering"],
			["guard_stayed_outside", "guard_is_vampire", "fake_will", "reference_entering"],
		],
		"friend_will_revelation"
	),
	#
	# --- NIECE ---
	# Ask niece about other people
	dt("niece", [["gardener_character"]], "niece_discuss_gardener"),
	dt("niece", [["guard_character"]], "niece_discuss_guard"),
	dt("niece", [["friend_character"]], "niece_discuss_friend"),
	dt("niece", [["cook_character"]], "niece_discuss_cook"),
	# Other
	dt("niece", [["vase"], ["broken_table"], ["vase", "broken_table"]], "niece_vase"),
	dt("niece", [["fake_will"]], "niece_will"),
	dt("niece", [["guard_is_vampire"]], "niece_guard_vampire"),
	dt(
		"niece",
		[
			["guard_is_vampire", "fake_will"],
			["guard_stayed_outside", "guard_is_vampire", "fake_will"],
			["guard_is_vampire", "fake_will", "reference_entering"],
			["guard_stayed_outside", "guard_is_vampire", "fake_will", "reference_entering"],
			["niece_planted_will"],
		],
		"niece_will_accusation"
	),
	dt("niece", [["cook_niece_cooperating", "niece_planted_will"]], "niece_bribery_accusation"),
	dt("niece", [["cook_niece_cooperating"]], "detective_niece_pondering", true),
	#
	# --- GUARD ---
	# Ask guard about other people
	dt("guard", [["cook_character"]], "guard_discuss_cook"),
	dt("guard", [["gardener_character"]], "guard_discuss_gardener"),
	dt("guard", [["niece_character"]], "guard_discuss_niece"),
	dt("guard", [["friend_character"]], "guard_discuss_friend"),
	# Other
	dt("guard", [["garlic_pouch"]], "guard_garlic"),
	dt("guard", [["guard_stayed_outside"]], "guard_staying_outside"),
	dt(
		"guard",
		[["vase"], ["broken_table"], ["vase", "broken_table"], ["someone_in_hallway"]],
		"guard_vase"
	),
	dt("guard", [["guard_hates_garlic"]], "detective_guard_garlic_first_pondering", true),
	dt(
		"guard",
		[["guard_stayed_outside", "reference_entering"]],
		"detective_guard_outside_pondering",
		true
	),
	dt(
		"guard",
		[["guard_hates_garlic", "reference_garlic"]],
		"detective_guard_garlic_pondering",
		true
	),
	dt(
		"guard",
		[
			["guard_stayed_outside", "guard_hates_garlic"],
			["guard_stayed_outside", "guard_hates_garlic", "reference_garlic"],
			["guard_stayed_outside", "guard_hates_garlic", "reference_entering"],
			[
				"guard_stayed_outside",
				"guard_hates_garlic",
				"reference_garlic",
				"reference_entering",
			],
		],
		"guard_identity_revealed",
	),
]

var used_triggers: Array[int] = []


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_end_dialogue") and Dialogic.current_timeline != null:
		Dialogic.end_timeline(true)


func submit_evidence(character: String, tags: Array[String]) -> void:
	var right_track: bool = false

	var i: int = -1
	for trig in triggers:
		i += 1

		var found_match = false

		for trig_tags in trig.tags:
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
				continue
			found_match = true
			break

		if not found_match:
			continue

		if trig.character != character:
			if len(tags) >= 2 and not i in used_triggers:
				right_track = true
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
		if right_track:
			Dialogic.start("detective_wrong_character")
		else:
			Dialogic.start("detective_unsure")
