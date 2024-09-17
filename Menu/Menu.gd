extends Control

onready var bg_tiles_sea: TileMap = $BgTilesSea

export (AudioStreamOGGVorbis) var main_theme

var tilemap_coords = []

func _ready() -> void:
	var tileArray: Array = bg_tiles_sea.get_used_cells_by_id(0)
	tilemap_coords.append(tileArray)
	Signals.play_Theme(main_theme, self)
