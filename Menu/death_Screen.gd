extends Control

onready var animation = $AnimationPlayer
onready var choice = $ColorRect/choice
onready var btn = $ColorRect/Button
onready var retry = $ColorRect/choice/retry
onready var quit = $ColorRect/choice/quit

var array = [
	"res://Menu/vid0.webm",
	"res://Menu/vid1.webm",
	"res://Menu/Mount Vesuvius vs baby.webm"
]

func _ready() -> void:
#	Signals.player_Selected.connect("dead", self, "choice")
	animation.connect("animation_finished", self, "anim_end")
	btn.connect("button_down", self, "animated")
	quit.connect("button_up", Signals, "quit")
	retry.connect("button_up", self, "retry")

func animated():
	var video = VideoPlayer.new()
	$".".add_child(video)
	video.connect("finished", video, "queue_free")
	video.rect_position = get_viewport_rect().position
	video.rect_size = Vector2(640,360)
	video.expand = true
	var i = ShopItems.rng.randi() % array.size()
	video.stream = load(array[i]) as VideoStreamWebm
	video.play()

func retry():
	get_tree().change_scene_to(preload("res://Menu/Menu.tscn"))
	get_tree().root.get_node("/root/World").queue_free()
	get_parent().queue_free()
	Signals.emit_signal("restart")

func anim_end(anim: String):
	if anim == "on_show":
		choice.visible = true
		animation.play("wait_option")
