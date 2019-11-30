extends TextureRect

export var level = 1
export var score = 0
export var lives = 3
export var health = 100
export var ammo = 8

func _ready():
	Global.GlobalHUD = self
	Global.HUD_level = level
	Global.HUD_score = score
	Global.HUD_lives = lives
	Global.HUD_health = health
	Global.HUD_ammo = ammo
	Global.HUD_weapon = self.get_node("Spr-Weapon")
	
	$"Lbl-Level".text = str(Global.HUD_level)
	$"Lbl-Score".text = str(Global.HUD_score)
	$"Lbl-Lives".text = str(Global.HUD_lives)
	$"Lbl-Health".text = str(Global.HUD_health)
	$"Lbl-Ammo".text = str(Global.HUD_ammo)
	

func on_ammo_changed(amount):
	if Global.HUD_ammo + amount >= 0:
		Global.HUD_ammo += amount
		Global.HUD_ammo = clamp(Global.HUD_ammo, 0, 99)
		$"Lbl-Ammo".text = str(Global.HUD_ammo)

func on_weapon_change(weapon):
	Global.HUD_weapon.frame = weapon -1

func on_health_changed(amount):
	Global.HUD_health += amount
	Global.HUD_health = clamp(Global.HUD_health, 0, 100)
	$"Lbl-Health".text = str(Global.HUD_health)

func on_treasure_collected(amount):
	Global.HUD_score += amount
	Global.HUD_score = clamp(Global.HUD_score, 0, 99999)
	$"Lbl-Score".text = str(Global.HUD_score)

func on_extralife_collected(amount):
	Global.HUD_lives += amount
	Global.HUD_lives = clamp(Global.HUD_lives, 0, 9)
	$"Lbl-Lives".text = str(Global.HUD_lives)

func on_enemy_killed(amount):
	Global.HUD_score += amount
	Global.HUD_score = clamp(Global.HUD_score, 0, 99999)
	$"Lbl-Score".text = str(Global.HUD_score)
