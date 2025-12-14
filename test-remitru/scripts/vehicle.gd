extends CharacterBody3D
class_name Vehicle

@export var speed: float = 6.0

enum VehicleType {
	MOTO,
	VAN,
	TRUCK
}
@export var type: VehicleType = VehicleType.MOTO

@export var max_cargo: int = 10
@export var fuel_efficiency: float = 1.0 # 1.0 = normal, <1 = consume menos
@export var reliability: float = 1.0     # 1.0 = fiable, <1 = falla más con mal mantenimiento
@export var maintenance_level: float = 1.0 # 1.0 = perfecto, 0.0 = roto

var current_mission: Mission = null
var path: Array[Vector3] = []
var path_index: int = 0
var on_mission: bool = false

signal mission_route_completed(vehicle: Vehicle, mission: Mission)

func assign_mission(mission: Mission, path_points: Array[Vector3]) -> void:
	if mission == null or path_points.is_empty():
		print("VEHICLE: assign_mission llamado con datos inválidos")
		return

	current_mission = mission
	path = path_points.duplicate()
	path_index = 0
	on_mission = true
	global_position = path[0]

	print("VEHICLE: misión asignada. Path size =", path.size())
	print("VEHICLE: start pos =", global_position)

func _physics_process(_delta: float) -> void:
	if not on_mission or path.is_empty():
		return

	var target: Vector3 = path[path_index]
	var to_target: Vector3 = target - global_position
	var distance := to_target.length()

	if distance < 0.1:
		path_index += 1
		if path_index >= path.size():
			on_mission = false
			velocity = Vector3.ZERO
			print("VEHICLE: terminó el path")
			emit_signal("mission_route_completed", self, current_mission)
			return

	var dir: Vector3 = to_target.normalized()
	velocity = dir * speed
	move_and_slide()
