extends Node

func sortDistanceFromPlayerAsc(a, b):
  return a.translation.length() < b.translation.length()

func _scaling_factor(node:Spatial):
  if node.scale.x > 1:
    return node.scale.x
  return 1/node.scale.x
  
func sortScalingFactorAsc(a, b):
  return _scaling_factor(a) < _scaling_factor(b)
