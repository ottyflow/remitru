extends RefCounted
class_name Driver

## Clase Driver (driver.gd)
## Representa a un conductor asignable a vehículos.

var name: String = "Conductor"
var xp_level: int = 1
var driving_skill: float = 0.5 # 0.0 a 1.0, reduce probabilidad de accidentes
var stress_tolerance: float = 0.5 # 0.0 a 1.0, influye en eventos de presión
var salary_cost: int = 50 

enum Status {
	IDLE,
	ON_MISSION,
	RESTING
}
var status: Status = Status.IDLE

func _init(p_name: String, p_skill: float, p_stress: float) -> void:
	name = p_name
	driving_skill = clamp(p_skill, 0.1, 1.0)
	stress_tolerance = clamp(p_stress, 0.1, 1.0)
	# Costo basado en stats
	salary_cost = int(30 + (driving_skill * 50) + (stress_tolerance * 20))

func add_xp(amount: int) -> void:
	xp_level += amount
	# Aumentar un poco stats con la experiencia (max 1.0)
	driving_skill = min(driving_skill + 0.01, 1.0)
