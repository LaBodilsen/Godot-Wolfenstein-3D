extends KinematicBody

var killed = false
var shoot = false
var playing_anim = false
var direction = Vector3()
export var health = 30
export var move_speed = 1.5
export(String, FILE, "*.ogg, *.wav") var spot_player_sound
export(String, FILE, "*.ogg, *.wav") var gun_shoot_sound

var death1_sfx = "res://Assets/Sounds/Guard Death1.wav"
var death2_sfx = "res://Assets/Sounds/Guard Death2.wav"
var death3_sfx = "res://Assets/Sounds/Guard Death3.wav"
var death_sound
var death

onready var spotenemy_sound = load(spot_player_sound)
onready var shoot_sound = load(gun_shoot_sound)
onready var weapon_raycast = get_node("RayCast")
onready var animation_player = get_node("Sprite3D/AnimationPlayer")

var weapon_collider

#States for state machine
enum {GUARD, PATROL, ATTACK, CHASE, SPOTTED, AVOID}
export(String, "GUARD", "PATROL") var Initial_State = "GUARD"
var state 

func _ready():
	$AmoPackOnGround/Area/CollisionShape.disabled = true
	$AmoPackOnGround.visible = false
	if Initial_State == "GUARD":
		state = GUARD
	elif Initial_State == "PATROL":
		state = PATROL
	#Set random death sound
	death = round(rand_range(1, 3))
	if death == 1:
		death_sound = load(death1_sfx)
	elif death == 2:
		death_sound = load(death2_sfx)
	elif death == 3:
		death_sound = load(death3_sfx)
	

func _process(delta):
	if killed == true:
		return
	if playing_anim == true:
		return
	# Get angle to player.
	var dir_to = rad2deg(self.global_transform.basis.x.angle_to(Global.GlobalPlayer.global_transform.basis.z))
	var angle_to = rad2deg(self.global_transform.basis.z.angle_to(-Global.GlobalPlayer.global_transform.basis.z))
	angle_to = round(-angle_to/45)
	if dir_to >90:
		angle_to = 8 - angle_to
	var enemy_frame = fposmod(angle_to, 8)
	weapon_raycast.look_at(Vector3(Global.GlobalPlayer.global_transform.origin.x, self.global_transform.origin.y, Global.GlobalPlayer.global_transform.origin.z),Vector3.UP)
	
	match state:
		GUARD:
			$Sprite3D.frame = enemy_frame
			if enemy_frame == 0 or enemy_frame == 1 or enemy_frame == 7:# or enemy_frame == 1 or enemy_frame == 7:
				weapon_collider = weapon_raycast.get_collider() 
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Player"):
					$AudioStreamPlayer3D.stream = spotenemy_sound
					$AudioStreamPlayer3D.play()
					state = SPOTTED

		ATTACK:
			if shoot == true:
				weapon_collider = weapon_raycast.get_collider() 
				playing_anim = true
				$AudioStreamPlayer3D.stream = shoot_sound
				animation_player.play("Shoot")
				$AudioStreamPlayer3D.play()
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Player"):
						Global.GlobalPlayer.im_hit(-10)
				else:
					direction = (Global.GlobalPlayer.translation - self.translation).normalized()
					self.look_at(Vector3(Global.GlobalPlayer.global_transform.origin.x, self.global_transform.origin.y, Global.GlobalPlayer.global_transform.origin.z),Vector3.UP)
					state = CHASE
					shoot = false
			elif shoot == false:
				shoot = true
				playing_anim = true
				animation_player.play("Draw_Weapon")


		PATROL:
			$Sprite3D.frame = enemy_frame
			pass
		
		CHASE:
			
			move_and_slide(direction)

			
			animation_player.play("Walking"+str(enemy_frame))
			var dist2player = self.global_transform.origin.distance_to(Global.GlobalPlayer.global_transform.origin)
			if dist2player < 10:
				weapon_collider = weapon_raycast.get_collider() 
				if weapon_raycast.is_colliding() and weapon_collider.is_in_group("Player"):
					state = ATTACK
		
		SPOTTED:
			self.look_at(Vector3(Global.GlobalPlayer.global_transform.origin.x, self.global_transform.origin.y, Global.GlobalPlayer.global_transform.origin.z),Vector3.UP)
			var dist2player = self.global_transform.origin.distance_to(Global.GlobalPlayer.global_transform.origin)
			if dist2player > 10:
				direction = (Global.GlobalPlayer.translation - self.translation).normalized()
				self.look_at(Vector3(Global.GlobalPlayer.global_transform.origin.x, self.global_transform.origin.y, Global.GlobalPlayer.global_transform.origin.z),Vector3.UP)
				state = CHASE
			elif dist2player > 4:
				var dist2playerX = self.global_transform.origin.x - Global.GlobalPlayer.global_transform.origin.x
				var dist2playerZ = self.global_transform.origin.z - Global.GlobalPlayer.global_transform.origin.z
				
				if abs(dist2playerX) >= abs(dist2playerZ):
					if dist2playerX >= 0:
						self.rotate_y(deg2rad(-40))
					else:
						self.rotate_y(deg2rad(40))
				else:
					if dist2playerZ >= 0:
						self.rotate_y(deg2rad(-40))
					else:
						self.rotate_y(deg2rad(40))
				direction = -get_global_transform().basis.z.normalized()*move_speed
				state = AVOID
			elif dist2player > 2:
				state = ATTACK
		
		AVOID:
			animation_player.play("Walking"+str(enemy_frame))
			move_and_slide(direction)

			if self.is_on_wall():
				self.rotate_y(90)
				direction = -get_global_transform().basis.z.normalized()*move_speed
			yield(get_tree().create_timer(1),"timeout")
			state = ATTACK

func im_hit(hit_power):
	self.look_at(Vector3(Global.GlobalPlayer.global_transform.origin.x, self.global_transform.origin.y, Global.GlobalPlayer.global_transform.origin.z),Vector3.UP)
	health -= hit_power
	if health <= 0:
		killed = true
		animation_player.play("Killed")
		set_process(false)
		$AudioStreamPlayer3D.stream = death_sound
		$AudioStreamPlayer3D.play()
		$CollisionShape.disabled = true
		$AmoPackOnGround.visible = true
		$AmoPackOnGround/Area/CollisionShape.disabled = false
		Global.GlobalHUD.on_enemy_killed(100)
	elif health >0:
		animation_player.stop()
		animation_player.play("Hit")
		playing_anim = true
		state = SPOTTED

func _on_Play_animation_finished(anim_name):
	if anim_name:
		playing_anim = false
