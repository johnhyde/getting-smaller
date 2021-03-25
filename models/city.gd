extends Level


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#  translation = Vector3(0,0,0)
  child_scale = 0.01
  # don't forget blender is Z-up and Godot is Y-up
  child_pos = Vector3(0.035145, 0.024392, -0.006493)
#  scale = Vector3(0.029,0.029,0.029)
#  scale = Vector3(1,1,1)
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
