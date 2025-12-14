extends CanvasLayer
class_name GameUI

signal mission_selected(mission_id: String)

@onready var money_label: Label = $TopLeftPanel/MoneyLabel
@onready var reputation_label: Label = $TopLeftPanel/ReputationLabel
@onready var notification_label: Label = $NotificationLabel
@onready var missions_list: VBoxContainer = $MissionsList

var mission_map: Dictionary = {} # mission_id -> Mission

func _ready() -> void:
	notification_label.text = "UI lista"

func update_money(money: int) -> void:
	money_label.text = "Dinero: $" + str(money)

func update_reputation(rep: float) -> void:
	reputation_label.text = "Reputación: " + str(rep)

func add_mission_to_list(mission: Mission) -> void:
	if mission == null:
		return

	# A PARTIR DE ACÁ YA NO HAY MÁS RETURNS
	mission_map[mission.id] = mission

	var button: Button = Button.new()
	button.text = "%s | $%d | Riesgo: %d" % [
		mission.name,
		mission.reward,
		mission.risk_level
	]
	button.pressed.connect(Callable(self, "_on_mission_button_pressed").bind(mission.id))
	missions_list.add_child(button)

func clear_missions_list() -> void:
	for child in missions_list.get_children():
		child.queue_free()
	mission_map.clear()

func show_mission_result(mission: Mission, success: bool, result: Dictionary) -> void:
	if mission == null:
		return

	if success:
		var gain := int(result.get("gain", 0))
		notification_label.text = "Misión %s completada. Ganancia: $%d" % [
			mission.name,
			gain
		]
	else:
		var event_name := str(result.get("event", "incidente"))
		var cost := int(result.get("cost", 0))
		notification_label.text = "Misión %s falló. Evento: %s | Costo: $%d" % [
			mission.name,
			event_name,
			cost
		]

func show_notification(text: String) -> void:
	notification_label.text = text

func _on_mission_button_pressed(mission_id: String) -> void:
	emit_signal("mission_selected", mission_id)
