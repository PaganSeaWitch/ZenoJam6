extends Node2D

var ammo_position: Vector2 = null
var current_ammo: RigidBody3D = null
var armed: bool = false

signal reload

# Only for testing, REMOVE IN COMMIT!
func _init():
	Initialize()

# Sets up the initial positions for the line2D nodes
func Initialize():
	ammo_position = %Centre.position
	%LeftString.set_point_position(0, %LeftEnd.position)
	%RightString.set_point_position(0, %RightEnd.position)

# Place the provided ammo object into the centre
func LoadAmmo(ammo):
	current_ammo = ammo
	# Moves the ammo to the centre and connects the strings to it
	ammo_position = %Centre.position
	current_ammo.position = Vector3(ammo_position.x, ammo_position.y, 0)
	move_ammo()

# Connect the strings to the ammo if present
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Checks is there is any ammo to be moved
	if current_ammo == null: return
	
	move_ammo()

# Push the ammo object out and send 'the' signal
func fire():
	# Checks if we are loaded
	if current_ammo == null: return
	
	# Applies a impulse with X and Y equal to the oposite of the distance to the centre
	# and Z (forward) equal to the total stretch of the string
	current_ammo.apply_central_impulse(Vector3(%Centre.position.x - ammo_position.x, %Centre.position.y - ammo_position.y, Vector2(%Centre.position.x - ammo_position.x, %Centre.position.y - ammo_position.y).length()))
	
	# Cleans up to get ready for the next reload
	current_ammo = null
	armed = false
	ammo_position = %Centre.position
	move_ammo()
	emit_signal("reload")

# Check if the mouse is released, then fire
func _input(event):
	if current_ammo == null: return
	if event is InputEventMouseButton:
		if armed and not event.is_pressed():
			fire()
			return
		elif not armed and event.is_pressed():
			armed = true
	elif event is InputEventMouseMotion and armed:
		# Moved the ammo to the mouse, but not outside or above the corners or the catapult and not more than 400px below the centre
		ammo_position = event.position.clamp(Vector2(%LeftEnd.position.x, %Centre.position.y - 400), %RightEnd.position)
		move_ammo()

# Moves the ammo and strings to where they should be
func move_ammo():
	%LeftString.set_point_position(1, ammo_position)
	%RightString.set_point_position(1, ammo_position)
	current_ammo.position = Vector3(ammo_position.x, ammo_position.y, 0)
