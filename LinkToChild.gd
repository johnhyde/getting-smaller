extends LinkToLevel

class_name LinkToChild

export(String) var _target_scale
export(String) var _translation_x
export(String) var _translation_y
export(String) var _translation_z

func get_target_translation() -> Vector3:
  return Vector3(float(_translation_x), float(_translation_y), float(_translation_z))

func get_target_scale() -> float:
  return float(_target_scale)
  
func get_target_scene() -> PackedScene:
  if scene_path:
    scene = load(scene_path)
  return scene

func get_link_type():
  return 'child'

func get_complementary_link():
  return target_instance.get_node("LinkToParent")

func update_target_transform():
  target_instance.scale = parent.scale * get_target_scale()    
  target_instance.translation = get_target_translation()*parent.scale + parent.translation
