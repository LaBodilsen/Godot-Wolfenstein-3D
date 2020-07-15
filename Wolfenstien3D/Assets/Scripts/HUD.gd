extends TextureRect

export var level = 1
export var score = 0
export var lives = 3
export var health = 90
export var ammo = 8

onready var animation_player = get_node("Sprite/AnimationPlayer")
var ProjectResolution = Vector2()

func _ready():
#	ProjectResolution = OS.get_window_size()
#	self.rect_scale = Vector2(ProjectResolution.x/320, ProjectResolution.y/200)
	
	randomize()
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
	animation_player.play("LookAround1")
	on_health_changed(0) #set player face anim

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
	var animation = animation_player.get_animation("LookAround1")
	if Global.HUD_health < 10:
		animation.track_set_key_value(0, 0, 21)
		animation.track_set_key_value(0, 1, 21)
		animation.track_set_key_value(0, 2, 21)
		animation.track_set_key_value(0, 3, 21)
	elif Global.HUD_health < 20:
		animation.track_set_key_value(0, 0, 18)
		animation.track_set_key_value(0, 1, 20)
		animation.track_set_key_value(0, 2, 18)
		animation.track_set_key_value(0, 3, 19)
	elif Global.HUD_health < 30:
		animation.track_set_key_value(0, 0, 15)
		animation.track_set_key_value(0, 1, 17)
		animation.track_set_key_value(0, 2, 15)
		animation.track_set_key_value(0, 3, 16)
	elif Global.HUD_health < 40:
		animation.track_set_key_value(0, 0, 12)
		animation.track_set_key_value(0, 1, 14)
		animation.track_set_key_value(0, 2, 12)
		animation.track_set_key_value(0, 3, 13)
	elif Global.HUD_health < 50:
		animation.track_set_key_value(0, 0, 9)
		animation.track_set_key_value(0, 1, 11)
		animation.track_set_key_value(0, 2, 9)
		animation.track_set_key_value(0, 3, 10)
	elif Global.HUD_health < 60:
		animation.track_set_key_value(0, 0, 6)
		animation.track_set_key_value(0, 1, 8)
		animation.track_set_key_value(0, 2, 6)
		animation.track_set_key_value(0, 3, 7)
	elif Global.HUD_health < 80:
		animation.track_set_key_value(0, 0, 3)
		animation.track_set_key_value(0, 1, 5)
		animation.track_set_key_value(0, 2, 3)
		animation.track_set_key_value(0, 3, 4)
	else:
		animation.track_set_key_value(0, 0, 0)
		animation.track_set_key_value(0, 1, 2)
		animation.track_set_key_value(0, 2, 0)
		animation.track_set_key_value(0, 3, 1)

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

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	$Sprite/Timer.start()

func _on_Timer_timeout():
	$Sprite/Timer.set_wait_time(rand_range(0.2,2.0))
	animation_player.set_speed_scale(rand_range(0.2,1.5))
	animation_player.play("LookAround1")
