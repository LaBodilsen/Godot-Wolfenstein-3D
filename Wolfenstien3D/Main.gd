extends Node

var projectResolution=Vector2()

func _ready():
	projectResolution=OS.get_window_size()
#	_on_VBoxContainer_resized()
	_on_ViewportHUD_resized()
#	_on_Viewport__HUD_size_changed()
	
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Fullscreen_F12"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

func _on_VBoxContainer_resized():
	print("VBoxContainer resized")
	projectResolution=OS.get_window_size()
	$VBoxContainer.rect_size = projectResolution
	$VBoxContainer.margin_right = 0
	$VBoxContainer.margin_bottom = 0
	pass # Replace with function body.

func _on_ViewportLevel3D_resized():
	print("Level3D resized")
	#Viewport Level in 3D
	$VBoxContainer/ViewportLevel3D.rect_size = Vector2(projectResolution.x, (projectResolution.y/100)*80)
	$"VBoxContainer/ViewportLevel3D/Viewport - Game".size = Vector2(projectResolution.x, (projectResolution.y/100)*80)
	Global.GlobalPlayer._set_screen_size()
	pass # Replace with function body.

func _on_ViewportHUD_resized():
	$VBoxContainer/ViewportHUD.anchor_top = 0.8
	$VBoxContainer/ViewportHUD.anchor_right = 1
	$VBoxContainer/ViewportHUD.anchor_bottom = 1
	$VBoxContainer/ViewportHUD.rect_size = Vector2(projectResolution.x, (projectResolution.y/100)*20)
	$VBoxContainer/ViewportHUD.rect_position = Vector2(0, projectResolution.y/100*80)
	pass # Replace with function body.

func _on_Viewport__HUD_size_changed():
	$"VBoxContainer/ViewportHUD/Viewport - HUD".size = Vector2(320, 40)
	pass # Replace with function body.

