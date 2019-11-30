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

var weapon_collider
var projectResolution=Vector2(ProjectSettings.get_setting("display/window/size/width"),ProjectSettings.get_setting("display/window/size/height"))

func _ready():
	Global.GlobalPlayer = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().call_group("Enemy", "set_camera", self)
	#Set weapon scale and position relative to windows size
	$Control/Sprite.scale = Vector2(projectResolution.y/64,projectResolution.y/64)
	$Control/Sprite.frame = 5
	$Control.margin_left = -projectResolution.y/2
	$Control.margin_top = -projectResolution.y
	$Control.margin_right = projectResolution.y/2

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
	velocity = move_and_slide(velocity)

func _process(delta):
	#Player fire weapon 
	if Input.is_action_just_pressed("Fire") and $Control/Sprite/AnimationPlayer.is_playing() == false:
		if weapon_selected == 1:
			weapon_collider = weapon_raycast.get_collider() 
			$WeaponSound1.stream = weapon_sound
			$WeaponSound1.play()
			$Control/Sprite/AnimationPlayer.play(weapon_animation)
			if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
				weapon_collider.im_hit(weapon_hit_damage)

		elif weapon_selected == 2:
			if not Global.HUD_ammo == 0:
				Global.GlobalHUD.on_ammo_changed(-1)
				weapon_collider = weapon_raycast.get_collider() 
				$WeaponSound1.stream = weapon_sound
				$WeaponSound1.play()
				$Control/Sprite/AnimationPlayer.play(weapon_animation)
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
					weapon_collider.im_hit(weapon_hit_damage)

		elif weapon_selected == 3:
			$Control/Sprite/AnimationPlayer.play("RiseMachineGun")

		elif weapon_selected == 4:
			$Control/Sprite/AnimationPlayer.play("RiseChainGun")


	if Input.is_action_pressed("Fire") and $Control/Sprite/AnimationPlayer.is_playing() == false:
		if weapon_selected == 3 or weapon_selected == 4:
			if not Global.HUD_ammo == 0:
				Global.GlobalHUD.on_ammo_changed(-1)
				$WeaponSound1.stream = weapon_sound
				$Control/Sprite/AnimationPlayer.play(weapon_animation)
				weapon_collider = weapon_raycast.get_collider()
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Enemy"):
					weapon_collider.im_hit(weapon_hit_damage)

	if Input.is_action_just_released("Fire"):
		if weapon_selected == 3:
			$Control/Sprite/AnimationPlayer.play("LowerMachineGun")
		elif weapon_selected == 4:
			$Control/Sprite/AnimationPlayer.play("LowerChainGun")

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
		$Control/Sprite.frame = 0
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_2"):
		weapon_selected = 2
		weapon_hit_damage = 34
		weapon_animation = "FireGun"
		weapon_sound = sound_gun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		$Control/Sprite.frame = 5
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_3"):
		weapon_selected = 3
		weapon_hit_damage = 50
		weapon_animation = "FireMachineGun"
		weapon_sound = sound_machinegun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		$Control/Sprite.frame = 10
		Global.GlobalHUD.on_weapon_change(weapon_selected)
	elif event.is_action_pressed("Weapon_4"):
		weapon_selected = 4
		weapon_hit_damage = 100
		weapon_animation = "FireChainGun"
		weapon_sound = sound_chaingun
		weapon_raycast.cast_to = Vector3(0.0, 0.0 , -25.0)
		$Control/Sprite.frame = 15
		Global.GlobalHUD.on_weapon_change(weapon_selected)

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