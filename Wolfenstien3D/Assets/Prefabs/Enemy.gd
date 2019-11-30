extends StaticBody

var camera = null
var killed = false
var playing_anim = false
export var health = 100
export var rotation_frame_add = 0
export(String, FILE, "*.ogg") var sfx_death_sound
onready var death_sound = load(sfx_death_sound)
onready var amo_pack = load("res://Assets/Prefabs/Collectables/AmoPackOnGround.tscn")

func set_camera(player_camera):
	camera = player_camera

func _ready():
	$AmoPackOnGround/Area/CollisionShape.disabled = true
	$AmoPackOnGround.visible = false
	pass

func _process(delta):
	if camera == null:
		return
	if killed == true:
		return
	if playing_anim == true:
		return
	self.look_at(Vector3(camera.global_transform.origin.x, self.global_transform.origin.y, camera.global_transform.origin.z),Vector3(0,1,0))
	var enemy_angle = self.rotation_degrees.y + 180
	var enemy_frame = round(enemy_angle / 45) + rotation_frame_add
	enemy_frame = fmod(enemy_frame, 8) #clamp the value to be between 0 and 7

#	print (enemy_frame)
	$Sprite3D.frame = enemy_frame
	
func im_hit(hit_power):
	health -= hit_power
	if health <= 0:
		killed = true
		$Sprite3D/AnimationPlayer.play("Killed")
		$AudioStreamPlayer3D.stream = death_sound
		$AudioStreamPlayer3D.play()
		$CollisionShape.disabled = true
		$AmoPackOnGround.visible = true
		$AmoPackOnGround/Area/CollisionShape.disabled = false
		Global.GlobalHUD.on_enemy_killed(100)
	elif health >0:
		$Sprite3D/AnimationPlayer.play("Hit")
		playing_anim = true

func _on_Play_animation_finished(anim_name):
	if anim_name == "Hit":
		playing_anim = false
	if anim_name == "Killed":
		pass
