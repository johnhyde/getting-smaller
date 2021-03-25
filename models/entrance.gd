extends Level


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  child_scale = 0.029
#  child_scale = 1.0
  # don't forget blender is Z-up and Godot is Y-up
  child_pos = Vector3(0.414979, -0.54441, -0.280422)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
