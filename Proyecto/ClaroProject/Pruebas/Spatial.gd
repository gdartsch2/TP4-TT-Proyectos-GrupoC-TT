extends Spatial

var tiempoJuego = 0.0
onready var menu = $GUI
onready var puzzle = $Puzzle1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
func _input(event):
	if puzzle.getPuzzle()!=true:
		menuPausa(event)
		recapturarMouse(event)

func menuPausa(event):
	if event.is_action_pressed("ui_cancel"):
		if menu.getActivo() == false:
			menu.activarMenu(tiempoJuego)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func recapturarMouse(event):
	if event.is_action_pressed("Interactuar"):
		if menu.getActivo() == false:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

			
func _process(delta):
	tiempoJuego += delta

