extends KinematicBody

signal collided(delta)
signal got_lonely(delta)
signal moved(travel)

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
  velocity = velocity.linear_interpolate(vel, acceleration*delta)
  
  
  if $ComfortZone.get_overlapping_bodies().size() <= 1: # Kinematic is always with us
    emit_signal('got_lonely', delta)
    
  var travel = velocity*delta
  if travel.length() > 0.001:
    # Test whether we're going to hit a wall
    if $OuterGimbal/InnerGimbal/Whiskers.get_overlapping_bodies().size() > 1: # Kinematic is always with us
      emit_signal('collided', delta)

    var collision = move_and_collide(travel, true, true, true)

    if collision:
      State.last_hit_level_instance = collision.collider.owner.get_parent()
      travel = collision.travel
      travel = travel.slerp(travel.slide(collision.normal), 0)
      velocity = travel/delta
    emit_signal('moved', travel)

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

func save_state():
  return {
    "rotation_y": $OuterGimbal.rotation.y,
    "rotation_x": $OuterGimbal/InnerGimbal.rotation.x,
   }
  
func load_state(state):
  $OuterGimbal.rotation = Vector3(0, state.rotation_y, 0)
  $OuterGimbal/InnerGimbal.rotation = Vector3(state.rotation_x, 0, 0)
  pass
