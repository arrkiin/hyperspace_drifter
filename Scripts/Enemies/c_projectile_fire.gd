extends Component

export var spawn_reference_path : NodePath
onready var spawn_reference : Spatial = get_node(spawn_reference_path)

export var projectile_scene_name : String = "BasicProjectile"
onready var projectile_scene : PackedScene = load("res://Prefabs/%s.tscn" % projectile_scene_name)

onready var spawn_parent : Node = object.get_parent()

export var shot_speed : float = 10

onready var shot_timer : Timer = get_node("./Timer")

func enable() -> void:
	shot_timer.connect("timeout", self, "fire_projectile")
func disable() -> void:
	shot_timer.disconnect("timeout", self, "fire_projectile")

func _ready() -> void:
	m_globals.try_add_pool(projectile_scene)
	enable()

func fire_projectile() -> void:
	var spawn_position : Vector3 = spawn_reference.global_transform.origin
	var new_shot = m_globals.pools[projectile_scene].get_instance_as_child_at(spawn_parent, spawn_position)
	
	var shot_direction : Vector2 = -Vector2(spawn_reference.global_transform.basis.y.x, spawn_reference.global_transform.basis.y.y)
	new_shot.get_node("Velocity").internal_velocity = shot_direction * shot_speed
