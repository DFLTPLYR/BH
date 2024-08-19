extends CanvasLayer

onready var h_slider: HSlider = $PanelContainer/GridContainer/HSlider
onready var h_slider_2: HSlider = $PanelContainer/GridContainer/HSlider2
onready var h_slider_3: HSlider = $PanelContainer/GridContainer/HSlider3
onready var accept: TextureButton = $Label/Accept
onready var quit: TextureButton = $Label/Quit

func _ready() -> void:
	self.visible = false
	accept.connect("button_up", self, "visibility")
	quit.connect("button_up", Signals, "quit")
	h_slider.value = AudioServer.get_bus_volume_db(0)
	h_slider_2.value = AudioServer.get_bus_volume_db(1)
	h_slider_3.value = AudioServer.get_bus_volume_db(2)

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(0, h_slider.value)
	AudioServer.set_bus_volume_db(1, h_slider_2.value)
	AudioServer.set_bus_volume_db(2, h_slider_3.value)

	master_sound()
	sounds()
	effects()

func master_sound():
	if h_slider.value == h_slider.min_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)

func sounds():
	if h_slider_2.value == h_slider_2.min_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)

func effects():
	if h_slider_3.value == h_slider_3.min_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("paused"):
		visibility()

func visibility():
	if is_instance_valid(Signals.player_Selected):
		Signals.player_Selected.emit_signal("focus")
	self.visible = !self.visible
	get_tree().paused = !get_tree().paused
