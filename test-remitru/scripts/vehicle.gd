extends CharacterBody3D
class_name Vehicle
## Entidad Vehículo (vehicle.gd)
##
## Representa un vehículo físico en el mundo.
## Capaz de seguir una ruta de puntos (Pathfinding simple) y transportar carga.

@export var speed: float = 6.0

enum VehicleType {
	MOTO,
	VAN,
	TRUCK
}
@export var type: VehicleType = VehicleType.MOTO

# Estadísticas del vehículo
@export var max_cargo: int = 10
@export var fuel_efficiency: float = 1.0 # 1.0 = normal, <1 = consume menos
@export var reliability: float = 1.0     # 1.0 = fiable, <1 = falla más con mal mantenimiento
@export var maintenance_level: float = 1.0 # 1.0 = perfecto, 0.0 = roto

var current_mission: Mission = null
var current_driver: Driver = null
var path: Array[Vector3] = [] # Puntos de destino secuenciales
var path_index: int = 0
var on_mission: bool = false

signal mission_route_completed(vehicle: Vehicle, mission: Mission)

## Asigna una ruta y una misión activa al vehículo. 
## Teletransporta al inicio de la ruta inmediatamente (simplificación).
func assign_mission(mission: Mission, assigned_driver: Driver, path_points: Array[Vector3]) -> void:
	if mission == null or path_points.is_empty():
		print("VEHICLE: assign_mission llamado con datos inválidos")
		return

	if assigned_driver == null:
		print("VEHICLE: assign_mission sin driver!")
		return

	current_mission = mission
	current_driver = assigned_driver
	
	# Actualizar estado del driver
	current_driver.status = Driver.Status.ON_MISSION
	
	path = path_points.duplicate()
	path_index = 0
	on_mission = true
	
	# Mover al punto inicial inmediatamente
	global_position = path[0]

	print("VEHICLE: misión asignada a ", current_driver.name, ". Path size =", path.size())
	print("VEHICLE: start pos =", global_position)

## Procesa el movimiento frame a frame.
## Mueve el vehículo en línea recta hacia el siguiente punto del path.
func _physics_process(_delta: float) -> void:
	if not on_mission or path.is_empty():
		return

	var target: Vector3 = path[path_index]
	var to_target: Vector3 = target - global_position
	var distance := to_target.length()

	# Si llegamos al punto actual (margen 0.1m)
	if distance < 0.1:
		path_index += 1
		# Si ya no quedan puntos, terminamos la ruta
		if path_index >= path.size():
			on_mission = false
			velocity = Vector3.ZERO
			print("VEHICLE: terminó el path")
			emit_signal("mission_route_completed", self, current_mission)
			return

	# Movimiento simple: dirección * velocidad
	var dir: Vector3 = to_target.normalized()
	velocity = dir * speed
	move_and_slide()

## Aplica desgaste al vehículo.
## amount: Cantidad de desgaste (0.0 a 1.0) a restar de maintenance_level.
func apply_wear(amount: float) -> void:
	maintenance_level = clamp(maintenance_level - amount, 0.0, 1.0)
	print("VEHICLE: Desgaste aplicado. Nivel actual de mantenimiento: ", maintenance_level * 100, "%")

## Repara el vehículo al 100%.
func repair() -> void:
	maintenance_level = 1.0
	print("VEHICLE: Reparado al 100%")
