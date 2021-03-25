extends RayCast

class_name PlaceholderLevel

signal seen

export(PackedScene) var scene
export(String) var scene_path
export(String) var _target_scale
export(String) var _translation_x
export(String) var _translation_y
export(String) var _translation_z
var target_scale
var target_translation
var target_instance
var parent

func _ready():
  enabled = true
  if (!scene):
    scene = load(scene_path)
  target_translation = Vector3(float(_translation_x), float(_translation_y), float(_translation_z))
  target_scale = float(_target_scale)
  parent = get_parent()

func _physics_process(delta):
  cast_to = to_local(Vector3(0,0,0))
  if (is_colliding() && get_collider().name == "Camera"):
    enabled = false
    print("loading level: ", scene._bundled.names[0])
    if !target_instance:
      target_instance = scene.instance()
      target_instance.scale = parent.scale * target_scale
      target_instance.translation = target_translation*parent.scale + parent.translation
      get_node("/root/Root/World").add_child(target_instance)

  if target_instance && !target_instance.i_got_it:
    target_instance.scale = parent.scale * target_scale    
    target_instance.translation = target_translation*parent.scale + parent.translation
