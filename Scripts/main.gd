extends Node3D
var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$slingshot_3d.Initialize()
	$slingshot_3d.LoadAmmo($ammo_placeholder)
