extends MeshInstance

signal item_collected
export var item_amount = 8

func _ready():
	var err = $Area.connect("body_entered", self, "_on_Area_body_entered")
	if err != 0:
		print("Collectable Connect Error %d" % err)
		
func _on_Area_body_entered(body):
	if body.name == "Player":
		emit_signal("item_collected", self, item_amount)
		#queue_free()
