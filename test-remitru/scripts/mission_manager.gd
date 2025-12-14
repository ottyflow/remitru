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
	m.id = str(Time.get_ticks_msec())
	m.name = "Delivery #" + str(randi() % 1000)

	m.reward = 150 + randi() % 300
	m.base_cost = 30 + randi() % 70
	m.estimated_time = 30.0

	m.risk_level = randi() % 3 + 1
	m.risk_type = "robo"

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
	var risk_threshold := 0.15 * float(mission.risk_level) # 0.15 / 0.30 / 0.45 aprox

	if risk_roll < risk_threshold:
		# Falló la misión
		result.success = false
		result.event = mission.risk_type
		result.cost = mission.base_cost + randi_range(50, 150)
	else:
		# Misión exitosa
		result.success = true
		result.event = "ok"
		result.gain = mission.reward - mission.base_cost

	mission.status = Mission.STATUS_FINISHED
	active_missions.erase(mission)

	emit_signal("mission_finished", mission, result.success, result)

	# Opcional: generamos una nueva misión para mantener la lista llena
	var new_mission := _create_random_mission()
	active_missions.append(new_mission)
	emit_signal("mission_created", new_mission)

	return result
