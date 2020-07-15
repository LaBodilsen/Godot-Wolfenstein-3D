extends StaticBody

var is_door_open = false
var enemy_in_area = false
var player_in_area = true
var door_anim_playing = false

export(String, FILE, "*.ogg") var door_open_sound
export(String, FILE, "*.ogg") var door_close_sound

onready var open_sound = load(door_open_sound)
onready var close_sound = load(door_close_sound)

onready var animation_player = get_node("Front/AnimationPlayer")

func _ready():
	
	var err = $"../Area".connect("body_entered", self, "_on_StaticBody_body_entered")
	if err != 0:
		print("Door body entered Connect Error %d" % err)
	err = $"../Area".connect("body_exited", self, "_on_StaticBody_body_exited")
	if err != 0:
		print("Door body exited Connect Error %d" % err)

func on_Player_ActionPressed():
	if is_door_open == false and door_anim_playing == false:
		animation_player.play("Door Open") #Open Door
		$Front/AudioStreamPlayer3D.stream = open_sound
		$Front/AudioStreamPlayer3D.play()
		$Front/DoorAutoCloseTimer.start()
		door_anim_playing = true
		is_door_open = true
	elif is_door_open == true and door_anim_playing == false:
		animation_player.play_backwards("Door Open") #Close Door, play anim backwards
		$Front/AudioStreamPlayer3D.stream = close_sound
		$Front/AudioStreamPlayer3D.play()
		door_anim_playing = true
		is_door_open = false

func _on_StaticBody_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_in_area = true
		if is_door_open == false and door_anim_playing == false:
			animation_player.play("Door Open") #Open Door
			$Front/AudioStreamPlayer3D.stream = open_sound
			$Front/AudioStreamPlayer3D.play()
			$Front/DoorAutoCloseTimer.start()
			door_anim_playing = true
			is_door_open = true
	elif body.is_in_group("Player"):
		player_in_area = true

func _on_StaticBody_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_in_area = false
	if body.is_in_group("Player"):
		player_in_area = false

func _on_DoorAutoClose_timeout():
	if enemy_in_area == false and player_in_area == false and is_door_open == true and door_anim_playing == false:
			animation_player.play_backwards("Door Open") #Close Door, play anim backwards
			$Front/AudioStreamPlayer3D.stream = close_sound
			$Front/AudioStreamPlayer3D.play()
			door_anim_playing = true
			is_door_open = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Door Open":
		door_anim_playing = false
