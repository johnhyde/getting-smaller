extends Spatial

class_name Level

signal was_loaded
signal was_unloaded

var i_got_it = false;
var static_body
var basic_with_outline_mat = preload("res://basic.tres")
var max_scale = 10000.0
var min_scale = 0.0001

# Called when the node enters the scene tree for the first time.
func _ready():
#  add_to_group('levels')
  static_body = find_node('static_collision')
  # var material = static_body.get_parent().set_surface_material(0, basic_with_outline_mat)
  var timer = Timer.new()
  timer.connect('timeout', self, '_all_grown_up')
  timer.set_wait_time( .1 )
  timer.one_shot = true
  add_child(timer)
  timer.start()
    
func _all_grown_up():
  i_got_it = true
  emit_signal('was_loaded')

func world_translate(travel):
  global_translate(travel)

func world_scale(vec):
  var origin = translation
  translation = Vector3(0,0,0)
  scale_object_local(Vector3(vec, vec, vec))
  translation = origin * vec
  if !is_reasonable_scale(scale.x):
    unload_level()

func is_reasonable_scale(_scale) -> bool:
  return _scale < max_scale and _scale > min_scale

func is_quite_reasonable_scale(_scale) -> bool:
  return _scale < max_scale / 2 and _scale > min_scale * 100

func get_child_links() -> Array:
  var links = []
  for child in get_children():
    if child is LinkToChild:
      links.append(child)
  return links
  
func get_links() -> Array:
  var links = get_child_links()
  links.append($LinkToParent)
  return links

func get_child_instances() -> Array:
  var instances = []
  for child in get_children():
    if child is LinkToChild and child.target_instance:
      instances.append(child.target_instance)
  return instances

func unload_level(orphaned = false):
  queue_free()
  if scale.x > max_scale or orphaned:
    [].pop_front()
    var child_levels_by_distance = get_child_instances()
    child_levels_by_distance.sort_custom(U, "sortDistanceFromPlayerAsc")
    if !orphaned: # leave behind the one that the player's in
      child_levels_by_distance.pop_front()
    print('removing orphaned levels')
    for child_level in child_levels_by_distance:
      child_level.unload_level(true)
  print('unloading level: ', name)
  emit_signal("was_unloaded")
  
func save_state():
  return {
    "filename": filename,
    "scale": scale.x,
    "translation_x": translation.x,
    "translation_y": translation.y,
    "translation_z": translation.z
  }

func load_state(state):
  scale = Vector3(state.scale, state.scale, state.scale)
  translation = Vector3(state.translation_x, state.translation_y, state.translation_z)
  for link in get_links():
    link.load_target()
