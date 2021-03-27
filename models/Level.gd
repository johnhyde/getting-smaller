extends Spatial

class_name Level

signal was_loaded
signal was_unloaded

export(Array, Resource) var child_scenes = []
var child_instances = []
var i_got_it = false;
var scale_buffer = []
var translation_buffer = Vector3(0, 0, 0)
var static_body
var basic_with_outline_mat = preload("res://basic.tres")
#onready var starting_pos = translation / scale
#onready var trimesh = create_trimesh_collision()


# Called when the node enters the scene tree for the first time.
func _ready():
  add_to_group('levels')
  static_body = find_node('static_collision')
  var material = static_body.get_parent().set_surface_material(0, basic_with_outline_mat)
  var timer = Timer.new()
  timer.connect('timeout', self, '_all_grown_up')
  timer.set_wait_time( .1 )
  timer.one_shot = true
  add_child(timer)
  timer.start()
#  i_got_it = true
    
func _all_grown_up():
  i_got_it = true
  emit_signal('was_loaded')

func world_translate(travel):
  global_translate(travel)

func world_scale(vec):
  var origin = translation
  translation = Vector3(0,0,0)
  if shelved():
    scale_buffer[scale_buffer.size()-1] *= vec
  else:
    scale_object_local(Vector3(vec, vec, vec))
  var scalar_scale = get_scalar_scale()
  if scalar_scale > 100000:
    shelve_more()
  elif scalar_scale < 0.9:
    shelve_less()
  translation = origin * vec

func shelve_more():
  if !shelved():
    print('shelving ', name)
    hide()
    static_body.collision_layer = 0
    static_body.collision_mask = 0
  scale_buffer.append(1.0)

func shelve_less():
  if shelved():
    var leftover = scale_buffer.pop_back()
    print('UNshelving ', name)      
    if !shelved():
      show()
      static_body.collision_layer = 1
      static_body.collision_mask = 1
    print('potentially recursive')
    world_scale(leftover)
  elif get_scalar_scale() < .0001:
    queue_free()
    print('unloading level: ', name)
    emit_signal("was_unloaded")

func shelved() -> bool:
  return scale_buffer.size() > 0

func get_scalar_scale() -> float:
  if shelved():
    var _scale = scale_buffer[scale_buffer.size()-1]
    return _scale
  else:
    return scale.x
    
func cumulative_scale() -> float:
  var _scale = scale.x
  for shelved_scale in scale_buffer:
    _scale *= shelved_scale
  return _scale
