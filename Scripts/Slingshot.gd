extends Node2D

var leftLine: Line2D = null
var rightLine: Line2D = null
var leftEdge: Vector2 = null
var rightEdge: Vector2 = null
var centre: Vector2 = null
var ammo_position: Vector2 = null

var current_ammo: RigidBody3D = null
var armed: bool = false

signal reload

# Sets up the initial positions for the line2D nodes
func Initialize():
	leftLine = get_node("LeftString")
	leftEdge = get_node("LeftEnd").position
	rightLine = get_node("RightString")
	rightEdge = get_node("RightEnd").position
	ammo_position = centre

# Place the provided ammo object into the centre
func LoadAmmo(ammo):
	current_ammo = ammo
	current_ammo.position = Vector3(centre.x, centre.y, 0)
	leftLine.set_point_position(1, centre)
	rightLine.set_point_position(1, centre)

# Connect the strings to the ammo if present
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_ammo == null: return
	leftLine.set_point_position(1, ammo_position)
	rightLine.set_point_position(1, ammo_position)

# Push the ammo object out and send 'the' signal
func fire():
	if current_ammo == null:
		return
	
	# TODO Actually fire the ammo
	
	current_ammo = null
	armed = false
	ammo_position = centre
	emit_signal("reload")

# Check if the mouse is released, then fire
func _input(event):
	if current_ammo == null: return
	if not (event.is_pressed() and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		fire()
		return
	
	# TODO Move ammo_position to mouse and clamp to bounds
