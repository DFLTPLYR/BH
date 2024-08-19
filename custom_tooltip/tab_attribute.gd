extends GridContainer

export (String) var attribute_name
export (NodePath) onready var attribute_value = get_node(attribute_value) as Label

onready var attribute_name_label = $Attribute_Name

func _ready() -> void:
	attribute_name_label.text = attribute_name
