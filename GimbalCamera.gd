extends KinematicBody

signal collided(delta)
signal got_lonely(delta)
signal moved(travel)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouseSensitivity = 20
var movementSpeed = 1.5
var velocity = Vector3(0,0,0)
var acceleration = 10
var fovSpeed = 10.0
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  set_as_toplevel(true) # Don't scale the camera, scale the world!

func interpolate_scale(_scale, delta):
  return _scale*(1/(_scale - (_scale-1)*delta))

func _physics_process(delta):
  var direction = Vector3()
  if Input.is_action_pressed('go_forward'):
    direction.z -= 1
  if Input.is_action_pressed('go_backward'):
    direction.z += 1
  if Input.is_action_pressed('strafe_left'):
    direction.x -= 1
  if Input.is_action_pressed('strafe_right'):
    direction.x += 1
  if Input.is_action_pressed('go_up'):
    direction.y += 1
  if Input.is_action_pressed('go_down'):
    direction.y -= 1
  var vel = $OuterGimbal.transform * ($OuterGimbal/InnerGimbal.transform * (direction.normalized() * movementSpeed));
#  if vel != Vector3(0,0,0):
#    print(acceleration*delta)
  velocity = velocity.linear_interpolate(vel, acceleration*delta)
  # Test whether we're going to hit a wall
  # We can only add in delta here because we're not scaling the camera
#  var body_scale = $Body.scale
#  print($Body.scale)
#  $Body.scale = body_scale*1.5
#  print($Body.scale)
  if $OuterGimbal/InnerGimbal/Whiskers.get_overlapping_bodies().size() > 1: # Kinematic is always with us
    emit_signal('collided', delta)
#    print('collided')
  
  if $ComfortZone.get_overlapping_bodies().size() <= 1: # Kinematic is always with us
    emit_signal('got_lonely', delta)
#    print('got lonely')
  var travel = velocity*delta
  var collision = move_and_collide(travel, true, true, true)
##  $Body.scale = body_scale
#  if collision:
#    var col_pos = $OuterGimbal/InnerGimbal.to_local(collision.position)
#    $OuterGimbal/InnerGimbal/MeshInstance.translation = col_pos
#    var angle = rad2deg(velocity.angle_to(velocity.slide(collision.normal)))
#    print(angle)
#    if angle > 20:
#      emit_signal("collided", delta)

#  var new_direction = move_and_slide(velocity)
#  var collision = move_and_collide(velocity*delta)
  if collision:
    var col_pos = $OuterGimbal/InnerGimbal.to_local(collision.position)
#    $OuterGimbal/InnerGimbal/MeshInstance.translation = col_pos
    travel = collision.travel
    travel = travel.slerp(travel.slide(collision.normal), 0)
    velocity = travel/delta
#    print(travel.length())
#    print(slide.length())
#  print(travel)
  emit_signal('moved', travel)
    
    
#  var collision = translate_object_local(velocity*delta)
#  if (new_direction != velocity):
#    velocity = new_direction
    
#  if collision:
#    var new_direction = collision.normal
#    print(new_direction.length(), 'slide')
#    print(velocity.length(), 'before')
#    velocity = new_direction.normalized() *((new_direction.length() + velocity.length())/2)
#    var hmm = new_direction.normalized() * velocity.length()
#    velocity = hmm
#    velocity = velocity.linear_interpolate(hmm, velocity)
#    var relevance = 1 - clamp(abs(velocity.angle_to(new_direction)), 0, PI/4)/(PI/4)
#    var angle = rad2deg(velocity.angle_to(new_direction))
#    print(angle)
#    if angle > 20:
#      emit_signal('collided',delta)
#    print(relevance)
#    velocity = velocity.normalized().slerp(new_direction.normalized(), relevance*relevance) * velocity.length()
#    print('slid')
#  print(velocity.length(), 'after')
  
  if Input.is_action_just_pressed('ui_cancel'):
    if !paused:
      paused = true
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      paused = false
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  
  if Input.is_mouse_button_pressed(1):
    $OuterGimbal/InnerGimbal/Camera.fov += fovSpeed * delta
  if Input.is_mouse_button_pressed(2):
    $OuterGimbal/InnerGimbal/Camera.fov -= fovSpeed * delta
      
    
func _input(event):
  if event is InputEventMouseMotion && !paused:
    if event.relative.x != 0:
      $OuterGimbal.rotate_object_local(Vector3.UP, -event.relative.x * mouseSensitivity / OS.get_screen_size().x)
    if event.relative.y != 0:
      $OuterGimbal/InnerGimbal.rotate_object_local(Vector3.RIGHT, -event.relative.y * mouseSensitivity / OS.get_screen_size().x)
      $OuterGimbal/InnerGimbal.rotation.x = clamp($OuterGimbal/InnerGimbal.rotation.x, deg2rad(-95), deg2rad(95))
  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
