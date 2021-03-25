extends Spatial

#var zoomOutSpeed = 3.0
var zoomOutSpeed = 40.0
var zoomOutVelocity = 1
var zoomOutAcceleration = 20
var queuedZoom = 1

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# This is not the right formula, but it's close enough probably
func interpolate_scale(_scale, delta):
  return _scale/(delta - delta*_scale + _scale)
  
#func 
func _physics_process(delta):
  if Input.is_action_pressed('get_bigger'):
    get_bigger(delta)
  if Input.is_action_pressed('get_smaller'):
    get_smaller(delta)
  if queuedZoom != 1:
    zoomOutVelocity = queuedZoom
    queuedZoom = 1
    scale_world(Vector3(zoomOutVelocity, zoomOutVelocity, zoomOutVelocity))

func get_smaller(delta):
  queuedZoom *= interpolate_scale(zoomOutSpeed, delta)

func get_bigger(delta):
  queuedZoom /= interpolate_scale(zoomOutSpeed, delta)
  
func scale_world(vec):
  get_tree().call_group('levels', 'world_scale', vec)

func _on_Camera_collided(delta):
  get_smaller(delta)
  pass


func _on_Camera_got_lonely(delta):
  get_bigger(delta)


func _on_Camera_moved(travel):
  get_tree().call_group('levels', 'world_translate', -1 * travel)
