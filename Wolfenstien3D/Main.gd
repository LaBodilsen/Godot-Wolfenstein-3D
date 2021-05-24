extends Node

var projectResolution=Vector2()

func _ready():
	projectResolution=OS.get_window_size()
#	_change_resolution()

	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_up"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
		_change_resolution()

	if event.is_action("ui_left"):
		_change_resolution()
	if event.is_action("ui_right"):
		_change_resolution()
	if event.is_action("ui_down"):
		_set_size()
#	print($"VBoxContainer/ViewportLevel3D".margin_top)

func _set_size():
	projectResolution=OS.get_window_size()


func _change_resolution():

	projectResolution=OS.get_window_size()
	print(projectResolution)
	#Viewport Container
	$VBoxContainer.rect_size = projectResolution
	$VBoxContainer.rect_position = Vector2(0, 0)
	$VBoxContainer.anchor_left = 0
	$VBoxContainer.anchor_top = 0
	$VBoxContainer.anchor_right = 1
	$VBoxContainer.anchor_bottom = 1
	$VBoxContainer.margin_left = 0
	$VBoxContainer.margin_top = 0
	$VBoxContainer.margin_right = 0
	$VBoxContainer.margin_bottom = 0

	#Viewport Level in 3D
	$"VBoxContainer/ViewportLevel3D/Viewport - Game".size = Vector2(projectResolution.x, (projectResolution.y/100)*80)
	$VBoxContainer/ViewportLevel3D.rect_size = Vector2(projectResolution.x, (projectResolution.y/100)*80)
	$VBoxContainer/ViewportLevel3D.rect_position = Vector2(0, 0)
	$VBoxContainer/ViewportLevel3D.margin_left = 0
	$VBoxContainer/ViewportLevel3D.margin_top = 0
	$VBoxContainer/ViewportLevel3D.margin_right = projectResolution.x
	$VBoxContainer/ViewportLevel3D.margin_bottom = (projectResolution.y/100)*80
	$VBoxContainer/ViewportLevel3D.anchor_left = 0	
	$VBoxContainer/ViewportLevel3D.anchor_top = 0	
	$VBoxContainer/ViewportLevel3D.anchor_right = 0	
	$VBoxContainer/ViewportLevel3D.anchor_bottom = 0	

	#Viewport HUD in 2D
	$VBoxContainer/ViewportHUD.stretch = true
	$VBoxContainer/ViewportHUD.stretch_shrink = 1
	$VBoxContainer/ViewportHUD.anchor_left = 0
	$VBoxContainer/ViewportHUD.anchor_top = 0.8
	$VBoxContainer/ViewportHUD.anchor_right = 1
	$VBoxContainer/ViewportHUD.anchor_bottom = 1
	$VBoxContainer/ViewportHUD.margin_left = 0
	$VBoxContainer/ViewportHUD.margin_right = 0
	$VBoxContainer/ViewportHUD.margin_bottom = 0
	$VBoxContainer/ViewportHUD.margin_top = 0
	$VBoxContainer/ViewportHUD.rect_size = Vector2(projectResolution.x, (projectResolution.y/100)*20)
	$VBoxContainer/ViewportHUD.rect_position = Vector2(0, projectResolution.y/100*80)
	
	$"VBoxContainer/ViewportHUD/Viewport - HUD".size = Vector2(320, 40)

#	var scale_value = min(projectResolution.x/640, projectResolution.y/400)
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect".rect_size = projectResolution
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_size = projectResolution
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_scale = Vector2(scale_value, scale_value)
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_position.x = (projectResolution.x-(640*scale_value))/2
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_position.y = (projectResolution.y-(400*scale_value))/2

func _on_Viewport__Game_size_changed():
	print("Size changed")
	Global.GlobalPlayer._set_screen_size()
#	projectResolution=OS.get_window_size()
#	_change_resolution2()
	pass # Replace with function body.
