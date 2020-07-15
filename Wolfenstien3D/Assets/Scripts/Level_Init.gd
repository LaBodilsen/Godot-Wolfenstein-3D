extends Spatial

export var treasures = 0
#export var guards = 0

var next_level = "next_level"

export(String, FILE, "*.ogg,*.wav") var sfx_amo_pickup
export(String, FILE, "*.ogg,*.wav") var sfx_weapon3_Pickup
export(String, FILE, "*.ogg,*.wav") var sfx_weapon4_Pickup
export(String, FILE, "*.ogg,*.wav") var sfx_treasure_pickup1
export(String, FILE, "*.ogg,*.wav") var sfx_treasure_pickup2
export(String, FILE, "*.ogg,*.wav") var sfx_treasure_pickup3
export(String, FILE, "*.ogg,*.wav") var sfx_treasure_pickup4
export(String, FILE, "*.ogg,*.wav") var sfx_health_pickup1
export(String, FILE, "*.ogg,*.wav") var sfx_health_pickup2
export(String, FILE, "*.ogg,*.wav") var sfx_extralife_pickup

onready var amo_sound = load(sfx_amo_pickup)
onready var weapon3_sound = load(sfx_weapon3_Pickup)
onready var weapon4_sound = load(sfx_weapon4_Pickup)
onready var treasure_sound1 = load(sfx_treasure_pickup1)
onready var treasure_sound2 = load(sfx_treasure_pickup2)
onready var treasure_sound3 = load(sfx_treasure_pickup3)
onready var treasure_sound4 = load(sfx_treasure_pickup4)
onready var health_sound1 = load(sfx_health_pickup1)
onready var health_sound2 = load(sfx_health_pickup2)
onready var extralife_sound = load(sfx_extralife_pickup)


func _ready():
	#Connect all elevators to level script in scene 
	for all_elevators in get_tree().get_nodes_in_group("Elevators"):
		all_elevators.connect("send_end_of_level", self, "on_end_level")
	#Connect all weapons to level script in scene 
	for all_weapons in get_tree().get_nodes_in_group("Weapons"):
		all_weapons.connect("item_collected", self, "on_weapon_collected")
	#Connect all health to level script in scene 
	for all_health in get_tree().get_nodes_in_group("Health"):
		all_health.connect("item_collected", self, "on_health_collected")
	#Connect all Treasures to level script in scene 
	for all_treasures in get_tree().get_nodes_in_group("Treasures"):
		all_treasures.connect("item_collected", self, "on_treasure_collected")
	#Connect all extralifes to level script in scene 
	for all_extralifes in get_tree().get_nodes_in_group("ExtraLife"):
		all_extralifes.connect("item_collected", self, "on_extralife_collected")

	#Hide end level canvas fade
	$EndLevelFader/ColorRect.hide()
	$EndLevelStats/ColorRect.hide()

func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func on_weapon_collected(object, amount):
	print(object.name)
	if object.is_in_group("Amopack"):
		if not Global.HUD_ammo >= 99:
			$"Sound FX Player".stream = amo_sound
			$"Sound FX Player".play()
			Global.GlobalHUD.on_ammo_changed(amount)
			object.queue_free()
			$CollectorFlash/ColorRect/AnimationPlayer.play("WeaponItemCollected")
	if object.is_in_group("Weapon_3"):
		Global.weapon3_pickedup = true
		$"Sound FX Player".stream = weapon3_sound
		$"Sound FX Player".play()
		Global.GlobalHUD.on_ammo_changed(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("WeaponItemCollected")
	if object.is_in_group("Weapon_4"):
		Global.weapon4_pickedup = true
		$"Sound FX Player".stream = weapon4_sound
		$"Sound FX Player".play()
		Global.GlobalHUD.on_ammo_changed(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("WeaponItemCollected")

func on_health_collected(object, amount):
	print(object.name)
	if not Global.HUD_health >= 100:
		if object.is_in_group("HealthPack"):
			$"Sound FX Player".stream = health_sound1
			$"Sound FX Player".play()
			Global.GlobalHUD.on_health_changed(amount)
		elif object.is_in_group("FoodPlate"):
			$"Sound FX Player".stream = health_sound2
			$"Sound FX Player".play()
			Global.GlobalHUD.on_health_changed(amount)
		elif object.is_in_group("DogFood"):
			$"Sound FX Player".stream = health_sound2
			$"Sound FX Player".play()
			Global.GlobalHUD.on_health_changed(amount)
			object.queue_free()
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("HealthItemCollected")

func on_treasure_collected(object, amount):
	print(object.name)
	if object.is_in_group("GoldChalice"):
		$"Sound FX Player".stream = treasure_sound1
		$"Sound FX Player".play()
		Global.GlobalHUD.on_treasure_collected(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("TreasureItemCollected")
		treasures += 1
	elif object.is_in_group("GoldCross"):
		$"Sound FX Player".stream = treasure_sound2
		$"Sound FX Player".play()
		Global.GlobalHUD.on_treasure_collected(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("TreasureItemCollected")
		treasures += 1
	elif object.is_in_group("GoldChest"):
		$"Sound FX Player".stream = treasure_sound3
		$"Sound FX Player".play()
		Global.GlobalHUD.on_treasure_collected(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("TreasureItemCollected")
		treasures += 1
	elif object.is_in_group("GoldCrown"):
		$"Sound FX Player".stream = treasure_sound4
		$"Sound FX Player".play()
		Global.GlobalHUD.on_treasure_collected(amount)
		object.queue_free()
		$CollectorFlash/ColorRect/AnimationPlayer.play("TreasureItemCollected")
		treasures += 1

func on_extralife_collected(object, amount):
	print(object.name)
	$"Sound FX Player".stream = extralife_sound
	$"Sound FX Player".play()
	Global.GlobalHUD.on_extralife_collected(amount)
	Global.GlobalHUD.on_health_changed(99)
	Global.GlobalHUD.on_ammo_changed(25)
	object.queue_free()
	$CollectorFlash/ColorRect/AnimationPlayer.play("ExtraLifeItemCollected")

func on_end_level(next_level_to_load):
	next_level = next_level_to_load
	$EndLevelFader/EndLevelFadeTimer.start()
	$EndLevelFader/ColorRect.show()
	$EndLevelFader/ColorRect/AnimationPlayer.play("EndLevelFade")

func _on_EndLevelFadeTimer_timeout():
#	get_tree().change_scene(next_level)
#	get_tree().quit()
	$EndLevelStats/ColorRect.show()
