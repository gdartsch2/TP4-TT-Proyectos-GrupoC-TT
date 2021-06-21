extends Area

onready var puzzle = $"../Puzzle1"

func _on_Trampa_body_entered(body):
	puzzle.setPuzzle(true)
	get_tree().paused == true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	puzzle.show()
