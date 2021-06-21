extends Control

var enPuzzle = false

func getPuzzle():
	return enPuzzle

func setPuzzle(valor:bool):
	enPuzzle = valor
 

func _on_Opcion_1_pressed():
	setPuzzle(false)
	get_tree().change_scene("res://Interfaz/PantallaDerrota.tscn")
	hide() # Replace with function body.


func _on_Opcion_2_pressed():
	setPuzzle(false)
	get_tree().change_scene("res://Interfaz/PantallaDerrota.tscn")
	hide() # Replace with function body


func _on_Opcion_3_pressed():
	setPuzzle(false)
	get_tree().paused == false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
