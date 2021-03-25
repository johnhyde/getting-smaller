extends RayCast

signal seen


func _physics_process(delta):
  if enabled:
    cast_to = to_local(Vector3(0,0,0))
    if (is_colliding() && get_collider().name == "Camera"):
      enabled = false
      print("loading level: ", get_parent().child_scene._bundled.names[0])
      emit_signal("seen")
