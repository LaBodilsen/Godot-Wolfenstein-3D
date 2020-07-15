extends KinematicBody
class_name Player

#Keyboard variables
#export var move_speed = 5.0
#export var rotate_speed = 3.0
#mouse sensitivity
export(float,0.1,1.0) var mouse_sensitivity = 0.5
#physics
export(float,1.0, 10.0) var move_speed = 4.0
#variables
var mouse_motion = Vector2()
var weapon_selected = 2
var weapon_animation = "FireGun"
var weapon_hit_damage = 34

export(String, FILE, "*.ogg,*.wav") var weapon_sound_knife
export(String, FILE, "*.ogg,*.wav") var weapon_sound_gun
export(String, FILE, "*.ogg,*.wav") var weapon_sound_machinegun
export(String, FILE, "*.ogg,*.wav") var weapon_sound_chaingun

onready var sound_knife = load(weapon_sound_knife)
onready var sound_gun = load(weapon_sound_gun)
onready var sound_machinegun = load(weapon_sound_machinegun)
onready var sound_chaingun = load(weapon_sound_chaingun)
onready var weapon_sound = sound_gun

onready var weapon_raycast = get_node("WeaponRayCast")
onready var interact_raycast = get_node("InteractRayCast")
onready var animation_player = get_node("Weapon/Sprite/AnimationPlayer")
onready var weapon_sprite = get_node("Weapon/Sprite")

var weapon_collider
var projectResolution=OS.get_window_size()

func _ready():
	Global.GlobalPlayer = self
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Set weapon scale and position relative to windows size
	weapon_sprite.scale = Vector2(projectResolution.y/64,projectResolution.y/64)
	weapon_sprite.frame = 5
	$Weapon.margin_left = -projectResolution.y/2
	$Weapon.margin_top = -projectResolution.y
	$Weapon.margin_right = projectResolution.y/2

func _physics_process(delta):

#KeyBoard controls movement
#	var z_movement : float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	var rotate : float = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
#	rotation.y += rotate * rotate_speed * delta
#	var direction : Vector3 = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), rotation.y)
#	var motion : Vector3 = direction * z_movement * move_speed
#	move_and_slide(motion)

#Mouse controls movement
	rotate_y(deg2rad(1)* - mouse_motion.x * mouse_sensitivity)
	mouse_motion = Vector2()

	#character movement
	var velocity = Vector3()
	velocity = _axis() * move_speed
	velocity = move_and_slide(Vector3(velocity.x, 0.0, velocity.z))

#get keyboard movement
func _axis():
	var direction = Vector3()
	if Input.is_action_pressed("Forward"):
		direction -= get_global_transform().basis.z.normalized()
	if Input.is_action_pressed("Backward"):
		direction += get_global_transform().basis.z.normalized()
	if Input.is_action_pressed("Strafe_left"):
		direction -= get_global_transform().basis.x.normalized()
	if Input.is_action_pressed("Strafe_right"):
		direction += get_global_transform().basis.x.normalized()
	return direction.normalized()
	
func _process(delta):
	#Player fire weapon 
	if Input.is_action_just_pressed("Fire") and animation_player.is_playing() == false:
		if weapon_selected == 1:
			weapon_collider = weapon_raycast.get_collider() 
			$WeaponSound1.stream = weapon_sound
			$WeaponSound1.play()
			weapon_hit_damage = rand_range(0, 15)
			animation_player.play(weapon_animation)
			if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
				weapon_collider.im_hit(weapon_hit_damage)

		elif weapon_selected == 2:
			if not Global.HUD_ammo == 0:
				Global.GlobalHUD.on_ammo_changed(-1)
				weapon_collider = weapon_raycast.get_collider() 
				$WeaponSound1.stream = weapon_sound
				$WeaponSound1.play()
				weapon_hit_damage = rand_range(0, 50)
				animation_player.play(weapon_animation)
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
					weapon_collider.im_hit(weapon_hit_damage)

		elif weapon_selected == 3:
			animation_player.play("RiseMachineGun")

		elif weapon_selected == 4:
			animation_player.play("RiseChainGun")


	if Input.is_action_pressed("Fire") and animation_player.is_playing() == false:
		if weapon_selected == 3 or weapon_selected == 4:
			if not Global.HUD_ammo == 0:
				Global.GlobalHUD.on_ammo_changed(-1)
				$WeaponSound1.stream = weapon_sound
				if  weapon_animation == "FireChainGun1":
					weapon_animation = "FireChainGun2"
				elif weapon_animation == "FireChainGun2":
					weapon_animation = "FireChainGun1"
				animation_player.play(weapon_animation)
				weapon_hit_damage = rand_range(0, 50)
				weapon_collider = weapon_raycast.get_collider()
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
					weapon_collider.im_hit(weapon_hit_damage)
			elif Global.HUD_ammo == 0 and weapon_selected == 4:
					weapon_sprite.frame = 16

	if Input.is_action_just_released("Fire"):
		if weapon_selected == 3:
			animation_player.play("LowerMachineGun")
		elif weapon_selected == 4:
			animation_player.play("LowerChainGun")

func _input(event):
	#Get mouse movement
	if event is InputEventMouseMotion:
		mouse_motion = event.relative

	#Send action pressed on spacebar pressed 
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		var interact_collider = interact_raycast.get_collider()
		if interact_raycast.is_colliding():
			if interact_collider.is_in_group("Interactable"):
				interact_collider.on_Player_ActionPressed()

	#Player change weapon 
	if event.is_action_pressed("Weapon_1") and not event.is_echo():
		weapon_selected = 1
		weapon_hit_damage = 25
		weapon_animation = "Knife_Stab"
		weapon_sound = sound_knife
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -1.0)
		weapon_sprite.frame = 0
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_2"):
		weapon_selected = 2
		weapon_hit_damage = 34
		weapon_animation = "FireGun"
		weapon_sound = sound_gun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		weapon_sprite.frame = 5
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_3") and Global.weapon3_pickedup == true:
		weapon_selected = 3
		weapon_hit_damage = 50
		weapon_animation = "FireMachineGun"
		weapon_sound = sound_machinegun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		weapon_sprite.frame = 10
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_4") and Global.weapon4_pickedup == true:
		weapon_selected = 4
		weapon_hit_damage = 50
		weapon_animation = "FireChainGun1"
		weapon_sound = sound_chaingun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		$Control/Sprite.frame = 15
		Global.GlobalHUD.on_weapon_change(weapon_selected)
		#Hover cheat mode
	elif event.is_action_pressed("UP"):
		self.translation.y = 2
	elif event.is_action_pressed("DOWN"):
		self.translation.y = 0.5

func im_hit(damage):
	Global.GlobalHUD.on_health_changed(damage)
	$Hit_Flash/ColorRect/AnimationPlayer.stop()
	$Hit_Flash/ColorRect/AnimationPlayer.play("Flash_hit")
	pass
