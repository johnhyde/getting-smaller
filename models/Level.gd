extends Spatial

class_name Level

export(Array, Resource) var child_scenes = []
var child_instances = []
var i_got_it = false;
var scale_buffer = []
var translation_buffer = Vector3(0, 0, 0)
var static_body
#onready var starting_pos = translation / scale
#onready var trimesh = create_trimesh_collision()


# Called when the node enters the scene tree for the first time.
func _ready():
  add_to_group('levels')
  static_body = find_node('static_collision')
  var timer = Timer.new()
  timer.connect('timeout', self, '_all_grown_up')
  timer.set_wait_time( .1 )
  timer.one_shot = true
  add_child(timer)
  timer.start()
#  i_got_it = true
    
func _all_grown_up():
  i_got_it = true

func world_translate(travel):
#  if shelved():
#    translation_buffer += travel
#  else:
  translation += travel

func world_scale(vec):
  if shelved():
    scale_buffer[scale_buffer.size()-1] *= vec
  else:
    var origin = translation
    translation = Vector3(0,0,0)
    scale_object_local(Vector3(vec, vec, vec))
    translation = origin * vec
  if get_scalar_scale() > 8:
    if !shelved():
      print('shelving ', name)
      hide()
      static_body.collision_layer = 0
##      translation_buffer = translation / scale.x
    scale_buffer.append(1.0)
#  if shelved():
#    if get_scalar_scale() < 1.0:
#      var leftover = scale_buffer.pop_back()
#      vec *= leftover
#      print('potentially recursive')
#      world_scale(leftover)
#      if !shelved():
#        show()
#        static_body.collision_layer = 1

func shelved():
  return scale_buffer.size() > 0

func get_scalar_scale():
  if shelved():
    var _scale = scale_buffer[scale_buffer.size()-1]
    return _scale
  else:
    return scale.x
