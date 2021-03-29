extends Node

var last_hit_level_instance

func _ready():
  pass # Replace with function body.

func get_current_level_instance():
#  assert(last_hit_level_instance, 'Error: the last one you hit is now gone, sorry')
  if last_hit_level_instance and last_hit_level_instance.is_inside_tree():
    return last_hit_level_instance
  var levels = get_tree().get_nodes_in_group('levels')
  levels.sort_custom(U, "sortDistanceFromPlayerAsc")
  levels = levels.slice(0,2)
  levels.sort_custom(U, "sortScalingFactorAsc")
  return levels.front()
