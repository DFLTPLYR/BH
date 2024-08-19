extends Camera2D

onready var tilemapMap = $"../Details/Water"
onready var camera = $"."

func _init() -> void:
	var cam_prop_tween = Tween.new()
	call_deferred("add_child", cam_prop_tween)
	Signals.cam_tween = cam_prop_tween

func _ready():
	set_camera_limits()
	Signals.camera = self

func set_camera_limits():
	var map_limits = tilemapMap.get_used_rect()
	var map_cellsize = tilemapMap.cell_size
	camera.limit_left = map_limits.position.x * map_cellsize.x
	camera.limit_right = map_limits.end.x * map_cellsize.x
	camera.limit_top = map_limits.position.y * map_cellsize.y
	camera.limit_bottom = map_limits.end.y * map_cellsize.y
