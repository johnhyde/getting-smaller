extends Spatial

#var zoomOutSpeed = 3.0
var zoomOutSpeed = 40.0
var zoomOutVelocity = 1
var zoomOutAcceleration = 20
var queuedZoom = 1
var title = "Getting Smaller"

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# This is not the right formula, but it's close enough probably
func interpolate_scale(_scale, delta):
  return _scale/(delta - delta*_scale + _scale)

func _process(delta):
    OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()))
#func 
func _physics_process(delta):
  if Input.is_action_pressed('get_bigger'):
    get_bigger(delta)
  if Input.is_action_pressed('get_smaller'):
    get_smaller(delta)
  if queuedZoom != 1:
    zoomOutVelocity = queuedZoom
    queuedZoom = 1
    scale_world(zoomOutVelocity)

func get_smaller(delta):
  queuedZoom *= interpolate_scale(zoomOutSpeed, delta)

func get_bigger(delta):
  queuedZoom /= interpolate_scale(zoomOutSpeed, delta)
  
func scale_world(vec):
  var current_level = State.get_current_level_instance()
  if current_level and !current_level.is_quite_reasonable_scale(current_level.scale.x * vec):
    return
  get_tree().call_group('levels', 'world_scale', vec)

func _on_Camera_collided(delta):
  get_smaller(delta)
  pass


func _on_Camera_got_lonely(delta):
  get_bigger(delta)


func _on_Camera_moved(travel):
  get_tree().call_group('levels', 'world_translate', -1 * travel)

func load_game_start():
  pass
  
func load_game():
  print("loading...")
  var save_game = File.new()
  if not save_game.file_exists("user://savegame.save"):
    load_game_start()
  else:
    get_tree().call_group('levels', 'queue_free')
    # Load the file line by line and process that dictionary to restore
    # the object it represents.
    save_game.open("user://savegame.save", File.READ)
    var game_state = parse_json(save_game.get_line())
    $Camera.load_state(game_state.camera_state)
    var level_state = game_state.level_state
    var level_instance = load(level_state.filename).instance()
    $World.add_child(level_instance)
    level_instance.load_state(level_state)
    save_game.close()
  print("loaded")

func save_game():
  print("saving...")
  var current_level_instance = State.get_current_level_instance()
  if !current_level_instance:
    print("Couldn't save because we couldn't find the current level instance")
    return
  var camera_state = $Camera.save_state()
  var level_state = current_level_instance.save_state()
  var game_state = {
    "camera_state": camera_state,
    "level_state": level_state,
   }
  var save_game = File.new()
  save_game.open("user://savegame.save", File.WRITE)
  save_game.store_line(to_json(game_state))
  save_game.close()
  print("saved")

func _input(event):
  if event.is_action_pressed("load_game"):
    load_game()
  elif event.is_action_pressed("save_game"):
    save_game()
