extends LinkToLevel

class_name LinkToParent

func get_link_type():
  return 'parent'

#func get_link_to_self_from_parent() -> LinkToChild:
func get_complementary_link():
  if target_instance:
    for child in target_instance.get_children():
      if child is LinkToChild and child.get_target_scene().resource_path == parent.filename:
        return child
    assert(false, "Error: Parent scene must link to this scene")
    
func update_target_transform():
  var link = get_complementary_link()
  target_instance.scale = parent.scale / link.get_target_scale()
  target_instance.translation = parent.translation - link.get_target_translation()*target_instance.scale
