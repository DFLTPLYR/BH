extends Node

onready var HUD_UI = preload("res://World/playerHUD.tscn").instance()
export (AudioStreamOGGVorbis) var main_theme

func _ready() -> void:
	get_tree().root.print_tree_pretty()
	randomize()
	add_child(HUD_UI)
	Signals.emit_signal("wave_Start")
	Signals.play_Theme(main_theme, self)
	if is_instance_valid(Signals.cam_tween):
		Signals.change_camera(Signals.player_Selected, Signals.player_Selected.eye_sight, 1.5)
		Signals.emit_signal("ready_World")
