extends Node
class_name MissionManager

signal mission_created(mission: Mission)
signal mission_started(mission: Mission)
signal mission_finished(mission: Mission, success: bool, result: Dictionary)

var active_missions: Array[Mission] = []

func _ready() -> void:
	randomize()
	# NO generamos misiones acá

func generate_initial_missions(count: int = 5) -> void:
	for i in range(count):
		var mission := _create_random_mission()
		active_missions.append(mission)
		emit_signal("mission_created", mission)

const MAP_MIN_X := -18.0
const MAP_MAX_X := 18.0
const MAP_MIN_Z := -18.0
const MAP_MAX_Z := 18.0

func _create_random_mission() -> Mission:
	var m := Mission.new()
	m.id = str(Time.get_ticks_msec()) + "_" + str(randi()) # ID un poco mas unico
	
	# Elegir tipo aleatorio
	var types = Mission.MissionType.values()
	m.type = types[randi() % types.size()]
	
	match m.type:
		Mission.MissionType.DELIVERY:
			m.name = "Reparto Std. #" + str(randi() % 1000)
			m.reward = 150 + randi() % 150
			m.base_cost = 20 + randi() % 30
			m.risk_level = 1
			m.risk_type = "retraso"
		Mission.MissionType.MULTIPLE:
			m.name = "Ruta Múltiple #" + str(randi() % 1000)
			m.reward = 350 + randi() % 200
			m.base_cost = 50 + randi() % 50
			m.risk_level = 2
			m.risk_type = "accidente"
		Mission.MissionType.URGENT:
			m.name = "URGENTE #" + str(randi() % 1000)
			m.reward = 600 + randi() % 300
			m.base_cost = 40 + randi() % 40
			m.risk_level = 3
			m.risk_type = "multa"
		_:
			m.name = "Encargo #" + str(randi() % 1000)
			m.reward = 200
			m.base_cost = 30
			m.risk_level = 1
			m.risk_type = "robo"

	m.estimated_time = 30.0

	var start_x = randf_range(MAP_MIN_X, MAP_MAX_X)
	var start_z = randf_range(MAP_MIN_Z, MAP_MAX_Z)
	var end_x = randf_range(MAP_MIN_X, MAP_MAX_X)
	var end_z = randf_range(MAP_MIN_Z, MAP_MAX_Z)

	m.start_point = Vector3(start_x, 0, start_z)
	m.end_point = Vector3(end_x, 0, end_z)

	m.status = Mission.STATUS_PENDING
	return m

func get_mission_by_id(mission_id: String) -> Mission:
	for m in active_missions:
		if m.id == mission_id:
			return m
	return null

func start_mission(mission: Mission) -> void:
	if mission == null:
		return
	mission.status = Mission.STATUS_IN_PROGRESS
	emit_signal("mission_started", mission)

func resolve_mission_result(mission: Mission) -> Dictionary:
	var result: Dictionary = {}
	var risk_roll := randf()
	# Probabilidad base de fallo aumenta con nivel de riesgo (0.15, 0.30, 0.45)
	var risk_threshold := 0.15 * float(mission.risk_level) 
	
	# TODO: Aqui se podrian aplicar modificadores del vehículo/conductor

	if risk_roll < risk_threshold:
		# Falló la misión o hubo incidente grave
		result.success = false
		result.event = mission.risk_type
		
		match mission.risk_type:
			"robo":
				result.cost = mission.base_cost + mission.reward * 0.5 # Pierde carga
				result.message = "Robo de carga! Perdiste mercancía."
			"accidente":
				result.cost = mission.base_cost + 200 # Reparaciones
				result.message = "Accidente en ruta. Vehículo dañado."
			"multa":
				result.cost = mission.base_cost + 100
				result.message = "Multa por exceso de velocidad."
			_:
				result.cost = mission.base_cost + 50
				result.message = "Incidente menor."
	else:
		# Misión exitosa
		result.success = true
		result.event = "ok"
		result.gain = mission.reward - mission.base_cost
		result.message = "Misión completada con éxito."

	mission.status = Mission.STATUS_FINISHED
	active_missions.erase(mission)

	emit_signal("mission_finished", mission, result.success, result)

	# Opcional: generamos una nueva misión para mantener la lista llena
	var new_mission := _create_random_mission()
	active_missions.append(new_mission)
	emit_signal("mission_created", new_mission)

	return result
