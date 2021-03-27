extends Spatial

class_name Level

export(Array, Resource) var child_scenes = []
var child_instances = []
var i_got_it = false;
var static_body
var basic_with_outline_mat = preload("res://basic.tres")
#onready var starting_pos = translation / scale
#onready var trimesh = create_trimesh_collision()


# Called when the node enters the scene tree for the first time.
func _ready():
  add_to_group('levels')
  static_body = find_node('static_collision')
#  var material = static_body.get_parent().get_surface_material(0)
  var material = static_body.get_parent().set_surface_material(0, basic_with_outline_mat)
#  material.next_pass = basic_with_outline_mat
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
  translation += travel

func world_scale(vec):
  var origin = translation
  translation = Vector3(0,0,0)
  scale_object_local(vec)
  translation = origin * vec

func _physics_process(delta):
  if scale.x > 10000:
    print(self.name, " is leaving because it got too big")
    queue_free()
