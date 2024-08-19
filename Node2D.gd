tool
extends Node2D

var num = 6

func _input(event: InputEvent):
	if event.is_action_released("debug1"):
		print(checker(num))


func checker(a:int) -> String:
	if a > 10:
		return "number is more than 1"
	elif a > 5:
		return "number is more than 5"
	elif a > 1:
		return "number is more than 10"
	else: 
		return "number is immeasurable"
