extends Resource
class_name Mission

# Datos básicos
@export var id: String = ""
@export var name: String = ""
@export var reward: int = 0        # Dinero que paga la misión
@export var base_cost: int = 0     # Coste estimado (combustible, peajes, etc.)
@export var estimated_time: float = 0.0

# Riesgo
@export var risk_level: int = 1    # 1 = bajo, 2 = medio, 3 = alto
@export var risk_type: String = "" # "robo", "accidente", etc.

# Puntos en el mapa
@export var start_point: Vector3 = Vector3.ZERO
@export var end_point: Vector3 = Vector3.ZERO

# Estado de la misión
const STATUS_PENDING := 0
const STATUS_IN_PROGRESS := 1
const STATUS_FINISHED := 2

var status: int = STATUS_PENDING
