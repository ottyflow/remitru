extends Node
class_name MissionManager
## Gestor de Misiones (mission_manager.gd)
##
## Esta clase se encarga de crear, administrar y resolver misiones.
## Contiene la lógica matemática para generar misiones aleatorias y calcular sus resultados (éxito/fracaso)
## basados en probabilidades.

signal mission_created(mission: Mission)
signal mission_started(mission: Mission)
signal mission_finished(mission: Mission, success: bool, result: Dictionary)

var active_missions: Array[Mission] = []
var staff: Array[Driver] = []

func _ready() -> void:
	randomize()
	# NO generamos misiones acá, se llama desde Main para asegurar orden de inicialización

## Genera un lote inicial de conductores.
func generate_initial_drivers(count: int = 3) -> void:
	var names = ["Juan", "Ana", "Carlos", "Sofia", "Miguel", "Lucia"]
	for i in range(count):
		var d_name = names[randi() % names.size()] + " " + str(randi() % 100)
		var skill = randf_range(0.3, 0.9)
		var stress = randf_range(0.3, 0.9)
		var new_driver = Driver.new(d_name, skill, stress)
		staff.append(new_driver)
		print("MISSION MANAGER: Nuevo conductor contratado: " + d_name)

## Genera un lote inicial de misiones.
func generate_initial_missions(count: int = 5) -> void:
	for i in range(count):
		var mission := _create_random_mission()
		active_missions.append(mission)
		emit_signal("mission_created", mission)

const MAP_MIN_X := -18.0
const MAP_MAX_X := 18.0
const MAP_MIN_Z := -18.0
const MAP_MAX_Z := 18.0

## Crea una nueva instancia de Misión con datos aleatorios.
## Configura recompensas, costos y riesgos según el tipo de misión.
func _create_random_mission() -> Mission:
	var m := Mission.new()
	m.id = str(Time.get_ticks_msec()) + "_" + str(randi()) # ID único basado en tiempo + random
	
	# Elegir tipo aleatorio
	var types = Mission.MissionType.values()
	m.type = types[randi() % types.size()]
	
	# Configurar parámetros según tipo
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

	# Puntos aleatorios en el mapa
	var start_x = randf_range(MAP_MIN_X, MAP_MAX_X)
	var start_z = randf_range(MAP_MIN_Z, MAP_MAX_Z)
	var end_x = randf_range(MAP_MIN_X, MAP_MAX_X)
	var end_z = randf_range(MAP_MIN_Z, MAP_MAX_Z)

	m.start_point = Vector3(start_x, 0, start_z)
	m.end_point = Vector3(end_x, 0, end_z)

	m.status = Mission.STATUS_PENDING
	return m

## Busca una misión activa por su ID.
func get_mission_by_id(mission_id: String) -> Mission:
	for m in active_missions:
		if m.id == mission_id:
			return m
	return null

## Marca una misión como iniciada.
func start_mission(mission: Mission) -> void:
	if mission == null:
		return
	mission.status = Mission.STATUS_IN_PROGRESS
	emit_signal("mission_started", mission)

## Determina el resultado final de una misión completada.
## Utiliza el `risk_level` de la misión y estado del vehículo para calcular probabilidades de fallo (RNG).
func resolve_mission_result(mission: Mission, assigned_vehicle: Vehicle = null) -> Dictionary:
	var result: Dictionary = {}
	var assigned_driver = assigned_vehicle.current_driver if assigned_vehicle else null
	
	# Aplicar Desgaste al Vehículo
	if assigned_vehicle:
		# Desgaste base 10% + variable por distancia/tipo (simplificado a 15% fijo por ahora)
		assigned_vehicle.apply_wear(0.15)
	
	var risk_roll := randf()
	# Probabilidad base de fallo aumenta con nivel de riesgo (0.15, 0.30, 0.45)
	var base_risk := 0.15 * float(mission.risk_level) 
	
	# Penalización por Mal Estado del Vehículo
	if assigned_vehicle and assigned_vehicle.maintenance_level < 0.5:
		# Si está bajo 50%, el riesgo aumenta drásticamente
		base_risk += (0.5 - assigned_vehicle.maintenance_level) * 0.5
		print("MISSION RESULT: Penalización por mal estado: +", (0.5 - assigned_vehicle.maintenance_level) * 0.5)

	# Mitigación por habilidad del conductor (si existe)
	var mitigation := 0.0
	if assigned_driver != null:
		mitigation = assigned_driver.driving_skill * 0.10 # Reduce hasta un 10% plano o algo asi
		# Ojo: si mitigation es muy alta, el risk se vuelve 0.
		# Ajuste: skill 1.0 reduce el riesgo a la mitad?
		# Formula: risk_final = base_risk * (1.0 - (skill * 0.5))
		base_risk = base_risk * (1.0 - (assigned_driver.driving_skill * 0.5))
		assigned_driver.add_xp(1)
	
	var risk_threshold := base_risk
	
	print("MISSION RESULT: Risk Roll: ", risk_roll, " Threshold: ", risk_threshold, " (Driver Skill: ", assigned_driver.driving_skill if assigned_driver else "None", ")")

	if risk_roll < risk_threshold:
		# Falló la misión o hubo incidente grave
		result.success = false
		result.event = mission.risk_type
		
		# Si el conductor tiene buen stress_tolerance, quizas reduce el costo del fallo?
		# Por ahora lo dejamos simple.
		
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
	
	# Liberar Driver
	if assigned_driver:
		assigned_driver.status = Driver.Status.IDLE

	emit_signal("mission_finished", mission, result.success, result)

	# Opcional: generamos una nueva misión para mantener la lista llena y que el juego continúe
	var new_mission := _create_random_mission()
	active_missions.append(new_mission)
	emit_signal("mission_created", new_mission)

	return result
