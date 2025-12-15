extends Node
## Clase Principal del Juego (main.gd)
##
## Esta clase actúa como el punto de entrada y controlador central del juego.
## Se encarga de:
## 1. Inicializar los sistemas (UI, MissionManager, Flota).
## 2. Coordinar la comunicación entre la UI y la lógica de juego.
## 3. Gestionar el ciclo de vida de la flota de vehículos y la asignación de misiones.

@onready var city: Node3D = $City
@onready var ui: GameUI = $UI
@onready var mission_manager: MissionManager = $MissionManager
@onready var vehicles_root: Node3D = $City/Vehicles

var money: int = 1000
var reputation: float = 0.0

const VEHICLE_SCENE := preload("res://scenes/entities/Vehicle.tscn")

# Límites del mapa para generación de puntos aleatorios
const MAP_MIN_X := -18.0
const MAP_MAX_X := 18.0
const MAP_MIN_Z := -18.0
const MAP_MAX_Z := 18.0

var fleet: Array[Vehicle] = []
var pending_mission_selection: Mission = null

func _ready() -> void:
    # Inicializar generador de números aleatorios
	randomize()

    # Conectar señales del MissionManager
	mission_manager.mission_created.connect(_on_mission_created)
	mission_manager.mission_finished.connect(_on_mission_finished)
    
    # Conectar señales de la UI
	ui.mission_selected.connect(_on_ui_mission_selected)
	ui.vehicle_selected.connect(_on_ui_vehicle_selected)

    # Crear la flota inicial de vehículos
	_spawn_initial_fleet()

	# AHORA sí generamos las misiones (después de conectar señales para recibir las notificaciones)
	mission_manager.generate_initial_missions(5)

    # Actualizar UI con valores iniciales
	ui.update_money(money)
	ui.update_reputation(reputation)
	ui.show_notification("Elegí una misión para empezar")

## Instancia y posiciona los vehículos iniciales del jugador.
func _spawn_initial_fleet() -> void:
	# Crear 3 vehículos: Moto, Van, Camion
	var types = [Vehicle.VehicleType.MOTO, Vehicle.VehicleType.VAN, Vehicle.VehicleType.TRUCK]
	
	for i in range(types.size()):
		var v = VEHICLE_SCENE.instantiate()
		vehicles_root.add_child(v)
		v.type = types[i]
		# Posicionamiento simple en linea
		v.global_position = Vector3(i * 3.0, 0, 0) 
		v.mission_route_completed.connect(_on_vehicle_mission_route_completed)
		fleet.append(v)
		print("MAIN: vehículo tipo ", v.type, " instanciado en ", v.global_position)

## Callback llamado cuando el MissionManager crea una nueva misión.
func _on_mission_created(mission: Mission) -> void:
	ui.add_mission_to_list(mission)

## Callback llamado cuando el usuario selecciona una misión en la lista de la UI.
func _on_ui_mission_selected(mission_id: String) -> void:
	var mission := mission_manager.get_mission_by_id(mission_id)
	if mission == null:
		ui.show_notification("Misión no encontrada.")
		return

	# Guardar seleccion y mostrar selector de vehiculos
	pending_mission_selection = mission
	ui.show_vehicle_selector(fleet)

## Callback llamado cuando el usuario selecciona un vehículo para realizar la misión pendiente.
func _on_ui_vehicle_selected(vehicle_index: int) -> void:
	if pending_mission_selection == null:
		return
	
	if vehicle_index < 0 or vehicle_index >= fleet.size():
		return
		
	var selected_vehicle = fleet[vehicle_index]
	if selected_vehicle.on_mission:
		ui.show_notification("Vehículo ocupado.")
		return # No deberia pasar si la UI deshabilita el botón
		
	_assign_mission_to_vehicle(selected_vehicle, pending_mission_selection)
	pending_mission_selection = null

## Asigna una misión a un vehículo específico y calcula la ruta.
func _assign_mission_to_vehicle(vehicle: Vehicle, mission: Mission) -> void:
	mission_manager.start_mission(mission)

	var path: Array[Vector3] = []
	path.append(mission.start_point)

	# Generar 2 puntos intermedios aleatorios para simular una ruta compleja
	for i in range(2):
		var x = randf_range(MAP_MIN_X, MAP_MAX_X)
		var z = randf_range(MAP_MIN_Z, MAP_MAX_Z)
		path.append(Vector3(x, 0, z))

	path.append(mission.end_point)

	vehicle.assign_mission(mission, path)
	ui.show_notification("Misión asignada a vehículo " + str(vehicle.type))


## Callback llamado cuando un vehículo termina su recorrido físico.
func _on_vehicle_mission_route_completed(_vehicle: Vehicle, mission: Mission) -> void:
	print("MAIN: vehículo reporta fin de ruta para misión:", mission.name)
    # Resolver el resultado de la misión (éxito o fallo por riesgo)
	mission_manager.resolve_mission_result(mission)

## Callback llamado cuando una misión ha finalizado (con éxito o fallo).
## Aquí se actualiza el dinero y la reputación.
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
	
	# Refrescar lista de misiones para quitar la finalizada y mostrar nuevas
	ui.clear_missions_list()
	for m in mission_manager.active_missions:
		ui.add_mission_to_list(m)

