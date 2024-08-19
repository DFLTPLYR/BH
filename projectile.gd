extends Area2D

signal done

onready var timer: Timer = $Timer

var Damage = null
export (int) var Piercing
export (int) var BulletSpeed 
export (int) var BulletLife 

func _ready() -> void:
	add_to_group("Projectiles")
	timer.wait_time = BulletLife
	timer.start()
	timer.connect("timeout", self, "lifetime")
	connect("area_entered", self, "hit")
	connect("area_exited", self, "hit_exited")
	emit_signal("done")

func _physics_process(delta: float) -> void:
	global_position += transform.x * BulletSpeed
	if Piercing <= 0:
		self.queue_free()


func lifetime() -> void:
	call_deferred("queue_free")

# warning-ignore:function_conflicts_variable
func hit(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(Damage)

func hit_exited(area: Area2D):
	Piercing -= 1
	if Piercing <= 0:
		self.queue_free()
