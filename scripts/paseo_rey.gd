extends Node3D

@export var velocidad_paseo: float = -0.1
@export var distancia_paseo: float = 5.0
@export var velocidad_bamboleo: float = 50
@export var amplitud_bamboleo: float = 1.5

var tiempo_total: float = 0.0
var pos_inicial: Vector3

func _ready():
	pos_inicial = position

func _process(delta):
	tiempo_total += delta * velocidad_paseo

	position.x = pos_inicial.x + (sin(tiempo_total) * distancia_paseo)

	rotation_degrees.z = sin(tiempo_total * velocidad_bamboleo) * amplitud_bamboleo

	if cos(tiempo_total) > 0:
		rotation_degrees.y = 0
	else:
		rotation_degrees.y = 180
