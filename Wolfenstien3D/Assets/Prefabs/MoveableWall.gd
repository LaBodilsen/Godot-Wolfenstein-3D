extends KinematicBody

export var move_direction = Vector3(0, 0, 0)
export(String, FILE, "*.ogg") var secret_open_sound
var door_is_moved = false

func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	var collision = move_and_collide(move_direction * delta)
	if collision:
		set_physics_process(false)

func on_Player_ActionPressed():
	if door_is_moved == false:
		set_physics_process(true)
		$AudioStreamPlayer3D.stream = load(secret_open_sound)
		$AudioStreamPlayer3D.play()
		door_is_moved = true
