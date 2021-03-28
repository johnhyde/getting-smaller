extends RayCast

class_name LinkToLevel

#enum 

export(PackedScene) var scene
export(String) var scene_path
export(bool) var autoload_target
var target_instance
var parent

func get_target_scene() -> PackedScene:
  if scene_path:
    scene = load(scene_path)
  return scene
  
func set_target_instance(_target_instance):
  target_instance = _target_instance
  target_instance.connect("was_unloaded", self, "_on_target_unloaded")

func _ready():
  parent = get_parent()
  scene = get_target_scene()
  assert(scene, "Error: A link must have a scene or scene path")
  if !target_instance:
    set_up_loader()
#    if autoload_target:
#      load_target()
#    else:
#      set_up_loader()

func should_load(test = false) -> bool:
#  if autoload_target:
#    return true
  cast_to = to_local(Vector3(0,0,0))
  return is_colliding() && get_collider().name == "Camera"

func get_link_type():
  return 'unimplemented'

func get_complementary_link():
  print('unimplemented')

func update_target_transform():
  print('unimplemented')
      
func _physics_process(delta):
  if should_load():
    load_target()
  if target_instance and !target_instance.i_got_it:
    update_target_transform()

func load_target():
  enabled = false
  if !target_instance:
    set_target_instance(get_target_scene().instance())
    update_target_transform()
    var link = get_complementary_link()
    link.set_target_instance(parent)
    link.scene_path = parent.filename
    get_node("/root/Root/World").add_child(target_instance)
    print("loading ", get_link_type(), " level: ", target_instance.name, ' from ', parent.name)

func set_up_loader():
  target_instance = null
  enabled = true
  
func _on_target_unloaded():
  # if !autoload_target:
  # target_instance.queue_free()
  set_up_loader()
