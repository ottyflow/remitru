extends Node

@onready var city: Node3D = $City
@onready var ui: GameUI = $UI
@onready var mission_manager: MissionManager = $MissionManager
@onready var vehicles_root: Node3D = $City/Vehicles

var money: int = 1000
var reputation: float = 0.0

const VEHICLE_SCENE := preload("res://scenes/entities/Vehicle.tscn")

const MAP_MIN_X := -18.0
const MAP_MAX_X := 18.0
const MAP_MIN_Z := -18.0
const MAP_MAX_Z := 18.0

var main_vehicle: Vehicle

func _ready() -> void:
	randomize()

	mission_manager.mission_created.connect(_on_mission_created)
	mission_manager.mission_finished.connect(_on_mission_finished)
	ui.mission_selected.connect(_on_ui_mission_selected)

	_spawn_initial_vehicle()

	# AHORA sí generamos las misiones (después de conectar señales)
	mission_manager.generate_initial_missions(5)

	ui.update_money(money)
	ui.update_reputation(reputation)
	ui.show_notification("Elegí una misión para empezar")

func _spawn_initial_vehicle() -> void:
	main_vehicle = VEHICLE_SCENE.instantiate()
	vehicles_root.add_child(main_vehicle)
	main_vehicle.global_position = Vector3(0, 0, 0)
	main_vehicle.mission_route_completed.connect(_on_vehicle_mission_route_completed)
	print("MAIN: vehículo instanciado en", main_vehicle.global_position)

func _on_mission_created(mission: Mission) -> void:
	ui.add_mission_to_list(mission)

func _on_ui_mission_selected(mission_id: String) -> void:
	if main_vehicle.on_mission:
		ui.show_notification("El vehículo ya está en una misión.")
		return

	var mission := mission_manager.get_mission_by_id(mission_id)
	if mission == null:
		ui.show_notification("Misión no encontrada.")
		return

	mission_manager.start_mission(mission)

	var path: Array[Vector3] = []
	path.append(mission.start_point)

	# 2 puntos intermedios aleatorios
	for i in range(2):
		var x = randf_range(MAP_MIN_X, MAP_MAX_X)
		var z = randf_range(MAP_MIN_Z, MAP_MAX_Z)
		path.append(Vector3(x, 0, z))

	path.append(mission.end_point)

	main_vehicle.assign_mission(mission, path)

func _on_vehicle_mission_route_completed(_vehicle: Vehicle, mission: Mission) -> void:
	print("MAIN: vehículo reporta fin de ruta para misión:", mission.name)
	mission_manager.resolve_mission_result(mission)

func _on_mission_finished(mission: Mission, success: bool, result: Dictionary) -> void:
	if success:
		money += int(result.get("gain", 0))
		reputation += 1.0
	else:
		money -= int(result.get("cost", 0))
		reputation = max(reputation - 1.0, 0.0)

	ui.update_money(money)
	ui.update_reputation(reputation)
	ui.show_mission_result(mission, success, result)

	ui.clear_missions_list()
	for m in mission_manager.active_missions:
		ui.add_mission_to_list(m)
