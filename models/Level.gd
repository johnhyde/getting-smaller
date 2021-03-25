extends Spatial

class_name Level

export(PackedScene) var child_scene
var child_instance
var child_scale
var child_pos
var i_got_it = false;
#onready var starting_pos = translation / scale
#onready var trimesh = create_trimesh_collision()


# Called when the node enters the scene tree for the first time.
func _ready():
  add_to_group('levels')
  var timer = Timer.new()
  timer.connect('timeout', self, '_all_grown_up')
  timer.set_wait_time( .1 )
  timer.one_shot = true
  add_child(timer)
  timer.start()
#  i_got_it = true
    
func _all_grown_up():
  i_got_it = true
  
  if child_scene:
    $CastToCamera.enabled = true

func world_translate(travel):
  translation += travel

func world_scale(vec):
  var origin = translation
  translation = Vector3(0,0,0)
  scale_object_local(vec)
  translation = origin * vec

func _on_RayCast_seen():
  if child_scene && !child_instance:
    child_instance = child_scene.instance()
    child_instance.scale = scale * child_scale
    child_instance.translation = child_pos*scale + translation
    get_parent().add_child(child_instance)

func _physics_process(delta):
  if child_instance && !child_instance.i_got_it:
    child_instance.scale = scale * child_scale    
    child_instance.translation = child_pos*scale + translation
  if scale.x > 10000:
    print(self.name, " is leaving because it got too big")
    queue_free()
    
