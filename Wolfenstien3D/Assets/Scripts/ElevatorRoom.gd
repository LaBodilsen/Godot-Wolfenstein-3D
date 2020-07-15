extends Spatial

var switch_down = preload("res://Assets/Prefabs/ElevatorRoomBack1.tres")
var switch_up = preload("res://Assets/Prefabs/ElevatorRoomBack2.tres")
var player_in_elevator = false
var button_pressed = false

signal send_end_of_level

export(String, FILE, "*.tscn") var next_level

func _ready():
	var err = $"../Area".connect("body_entered", self, "_on_player_body_entered")
	if err != 0:
		print("Elevator body entered Connect Error %d" % err)
	err = $"../Area".connect("body_exited", self, "_on_player_body_exited")
	if err != 0:
		print("Elevator body exited Connect Error %d" % err)

func on_Player_ActionPressed():
	if player_in_elevator == true and button_pressed == false:
		$Back.set_surface_material(0, switch_up)
		button_pressed = true
		emit_signal("send_end_of_level",next_level)
	elif player_in_elevator == true and button_pressed == true:
		$Back.set_surface_material(0, switch_down)
		button_pressed = false

func _on_player_body_entered(body):
	if body.name == "Player":
		player_in_elevator = true

func _on_player_body_exited(body):
	if body.name == "Player":
		player_in_elevator = false
