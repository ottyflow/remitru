extends Resource
class_name Mission
## Clase de Datos Misión (mission.gd)
##
## Esta clase es un Recurso (Resource) que almacena toda la información estática y dinámica de una misión.
## No contiene lógica compleja, solo datos.

# Identificador único y nombre para mostrar
@export var id: String = ""
@export var name: String = ""

# Economía de la misión
@export var reward: int = 0        # Dinero que paga la misión al completarse con éxito
@export var base_cost: int = 0     # Coste estimado (combustible, peajes, etc.)
@export var estimated_time: float = 0.0 # Tiempo base estimado (no usado activamente aún)

# Tipos de misión definidos para lógica futura
enum MissionType {
	DELIVERY,   # Entrega estándar
	MULTIPLE,   # Múltiples entregas (más riesgo)
	PASSENGER,  # Transporte de pasajeros (requiere cuidado)
	SPECIAL,    # Eventos especiales
	URGENT      # Requiere velocidad, alto riesgo de multa
}
@export var type: MissionType = MissionType.DELIVERY

# Sistema de Riesgo
@export var risk_level: int = 1    # 1 = bajo, 2 = medio, 3 = alto. Afecta probabilidad de fallo.
@export var risk_type: String = "" # Tipo de evento negativo: "robo", "accidente", "multa", "retraso"

# Puntos en el mundo 3D
@export var start_point: Vector3 = Vector3.ZERO
@export var end_point: Vector3 = Vector3.ZERO

# Estados posibles de la misión
const STATUS_PENDING := 0
const STATUS_IN_PROGRESS := 1
const STATUS_FINISHED := 2

var status: int = STATUS_PENDING
