extends Resource
class_name Item

export (String) var name = ""
export (Texture) var texture
export (String, FILE) var scene_path
export (Resource) var stats = null
export (String, FILE) var stat

func _init():
	call_deferred("ready")

func ready():
	var loaded = load(stat).duplicate(false) as Resource
	stats = loaded
	stats.compute()
