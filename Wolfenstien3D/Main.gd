extends Node

var projectResolution=Vector2()

func _ready():
	projectResolution=OS.get_window_size()
	_change_resolution()

	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_up"):
		OS.window_fullscreen = !OS.window_fullscreen
		projectResolution=OS.get_window_size()
		_change_resolution()
	if event.is_action("ui_left"):
		$"VBoxContainer/ViewportHUD".margin_top += 1
	if event.is_action("ui_right"):
		$"VBoxContainer/ViewportHUD".margin_top += -1
#	print($"VBoxContainer/ViewportLevel3D".margin_top)

func _change_resolution():
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
	$VBoxContainer/ViewportLevel3D.rect_size = Vector2(projectResolution.x, projectResolution.y/100*80)
	$VBoxContainer/ViewportLevel3D.rect_position = Vector2(0, 0)
	$VBoxContainer/ViewportLevel3D.margin_left = 0
	$VBoxContainer/ViewportLevel3D.margin_top = 0
	$VBoxContainer/ViewportLevel3D.margin_right = projectResolution.x
	$VBoxContainer/ViewportLevel3D.margin_bottom = projectResolution.y/100*80
	$VBoxContainer/ViewportLevel3D.anchor_left = 0	
	$VBoxContainer/ViewportLevel3D.anchor_top = 0	
	$VBoxContainer/ViewportLevel3D.anchor_right = 0	
	$VBoxContainer/ViewportLevel3D.anchor_bottom = 0	
	$"VBoxContainer/ViewportLevel3D/Viewport - Game".size = Vector2(projectResolution.x, projectResolution.y/100*80)
	#Viewport HUD in 2D
	var HUD_scale_value = min(projectResolution.x/320, projectResolution.y/200)
	$VBoxContainer/ViewportHUD.rect_size = Vector2(projectResolution.x, projectResolution.y/100*20)
	$VBoxContainer/ViewportHUD.rect_position = Vector2(0, projectResolution.y/100*80)
	$VBoxContainer/ViewportHUD.anchor_left = 0
	$VBoxContainer/ViewportHUD.anchor_top = 0
	$VBoxContainer/ViewportHUD.anchor_right = 0
	$VBoxContainer/ViewportHUD.anchor_bottom = 0
	$VBoxContainer/ViewportHUD.margin_left = 0
	$VBoxContainer/ViewportHUD.margin_top = projectResolution.y/100*80
	$VBoxContainer/ViewportHUD.margin_right = projectResolution.x
	$VBoxContainer/ViewportHUD.margin_bottom = projectResolution.y
	$"VBoxContainer/ViewportHUD/Viewport - HUD".size = Vector2(projectResolution.x, projectResolution.y/100*20)
	$"VBoxContainer/ViewportHUD/Viewport - HUD/HUD".rect_scale = Vector2(HUD_scale_value, HUD_scale_value)
	
	print(Vector2(projectResolution.x, projectResolution.y/100*80))
	print(Vector2(projectResolution.x, projectResolution.y/100*20))
	print(round((projectResolution.x-(320*HUD_scale_value))/2))

#	var scale_value = min(projectResolution.x/640, projectResolution.y/400)
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect".rect_size = projectResolution
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_size = projectResolution
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_scale = Vector2(scale_value, scale_value)
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_position.x = (projectResolution.x-(640*scale_value))/2
#	$"VBoxContainer/ViewportLevel3D/Viewport - Game/E1M1/EndLevelStats/ColorRect/TextureRect".rect_position.y = (projectResolution.y-(400*scale_value))/2
