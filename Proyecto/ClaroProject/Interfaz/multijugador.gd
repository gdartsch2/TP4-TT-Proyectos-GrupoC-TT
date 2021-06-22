extends Node

#onready var jugador_1_pos = $Jugador1Pos
#onready var jugador_2_pos = $Jugador2Pos

const PUERTO = 10567
const MAX_JUGADORES = 2

var peer = null
var nombre_jugador = "Sin Nombre"
var jugadores = {}
var jugadores_listos = {}
var rng = RandomNumberGenerator.new()
var nivel = 0

signal actualizacion_lista_jugadores()
signal conexion_fallida()
signal conexion_exitosa()
signal juego_terminado()
signal error_juego(error)

func _jugador_conectado(id):
	rpc_id(id, "registrar_jugador", nombre_jugador)
	
func _jugador_desconectado(id):
	if has_node("/root/Nivel1"):
		if get_tree().is_network_server():
			emit_signal("error_juego", "Jugador " + jugadores[id] + " se ha desconectado")
			terminar_juego()
	else:
		borrar_jugador(id)
		
func _conexion_ok():
	emit_signal("conexion_exitosa")
	
func _servidor_desconectado():
	emit_signal("error_juego", "Servidor desconectado")
	terminar_juego()
	
func _conexion_fallida():
	get_tree().set_network_peer(null)
	emit_signal("conexion_fallida")
	
remote func registrar_jugador(nombre_nuevo_jugador):
	var id = get_tree().get_rpc_sender_id()
	print(id)
	jugadores[id] = nombre_nuevo_jugador
	emit_signal("actualizacion_lista_jugadores")
	
func borrar_jugador(id):
	jugadores.erase(id)
	emit_signal("actualizacion_lista_jugadores")
	
remote func pre_inicio_juego():
<<<<<<< HEAD
	var jugador = load("res://Jugador/PrimeraPersona.tscn").instance()
	var nivel
	
	if get_tree().is_network_server():
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		nivel = rng.randi_range(0, 3)
			
	for j_id in jugadores:
		jugador.set_network_master(j_id)
		
=======
	var nivel = rng.randi_range(0, 3)
	var juego
>>>>>>> parent of f3526a5... conflictos
	if get_tree().get_network_unique_id() == 1:
		if nivel == 0:
			juego = load("res://Niveles/Nivel1.tscn").instance()
		elif nivel == 1:
			juego = load("res://Niveles/Nivel2.tscn").instance()
		elif nivel == 2:
			juego = load("res://Niveles/Nivel3.tscn").instance()
		else:
			juego = load("res://Niveles/Nivel4.tscn").instance()
	else:
		if nivel == 0:
			juego = load("res://Niveles/Nivel1P2.tscn").instance()
		elif nivel == 1:
			juego = load("res://Niveles/Nivel2P2.tscn").instance()
		elif nivel == 2:
			juego = load("res://Niveles/Nivel3P2.tscn").instance()
		else:
			juego = load("res://Niveles/Nivel4P2.tscn").instance()
<<<<<<< Updated upstream
=======
	#rpc_id(2, "cargar_mapa", nivel)
			
	if not get_tree().is_network_server():
		rpc_id(1, "juego_listo", get_tree().get_network_unique_id())
	elif jugadores.size() == 0:
		post_inicio_juego()
			
	print("Nivel: " + str(nivel))
>>>>>>> Stashed changes
		
	get_tree().get_root().add_child(juego)
	#get_tree().get_root().get_node("lobby").hide()
	#var escena_jugador = preload("res://Jugador/PrimeraPersona.tscn")
	#jugador.set_network_master(get_tree().get_network_unique_id())
	
	
#	or j_id in pos_spawn:
#		var pos_aparicion = juego.get_node("PuntosSpawn/" + str(pos_spawn[j_id])).position
#		var jugador = escena_jugador.instance()
#
#		jugador.set_name(str(j_id))
#		jugador.position = pos_aparicion
#		jugador.set_network_master(j_id)
#
#		if j_id == get_tree().get_network_unique_id():
#			jugador.set_player_name(nombre_jugador)
#		else:
#			jugador.set_player_name(jugadores[j_id])
#
#		juego.get_node("Jugadores").add_child(jugador)
#
#		if not get_tree().is_network_server():
#			rpc_id(1, "juego_listo", get_tree().get_network_unique_id())
#		elif jugadores.size() == 0:
#			post_inicio_juego()
			
remote func post_inicio_juego():
	get_tree().set_pause(false)
	
remote func juego_listo(id):
	assert(get_tree().is_network_server())
	
	if not id in jugadores_listos:
		jugadores_listos.append(id)
		
	if jugadores_listos.size() == jugadores.size():
		for j in jugadores:
			rpc_id(j, "post_inicio_juego")
		post_inicio_juego()
		
func crear_servidor(nombre_nuevo_jugador):
	nombre_jugador = nombre_nuevo_jugador
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PUERTO, MAX_JUGADORES)
	get_tree().set_network_peer(peer)
	
func unirse_servidor(ip, nombre_nuevo_jugador):
	nombre_jugador = nombre_nuevo_jugador
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PUERTO)
	get_tree().set_network_peer(peer)
	
func get_lista_jugadores():
	return jugadores.values()
	
func get_nombre_jugador():
	return nombre_jugador
	
func comenzar_juego():
	assert(get_tree().is_network_server())
	
	var pos_spawn = {}
	pos_spawn[1] = 0
	var pos_spawn_idx = 1
	for j in jugadores:
		pos_spawn[j] = pos_spawn_idx
		pos_spawn_idx += 1
		
	print(get_tree().get_network_unique_id())
		
	for j in jugadores:
		rpc_id(j, "pre_inicio_juego", pos_spawn)
		
	pre_inicio_juego()
	
func terminar_juego():
	if has_node("/root/CajaDeArenaDartsch"):
		get_node("/root/CajaDeArenaDartsch").queue_free()
		
	emit_signal("juego_terminado")
	jugadores.clear()
	
func _ready():
	get_tree().connect("network_peer_connected", self, "_jugador_conectado")
	get_tree().connect("network_peer_disconnected", self, "_jugador_desconectado")
	get_tree().connect("connected_to_server", self, "_conexion_ok")
	get_tree().connect("connection_failed", self, "_conexion_fallida")
	get_tree().connect("server_disconnected", self, "_servidor_desconectado")
