extends CanvasLayer
class_name GameUI
## Control de Interfaz de Usuario (ui.gd)
##
## Gestiona todos los elementos visuales 2D: botones de misión, notificaciones,
## paneles de estado (dinero, reputación) y selector de vehículos.

signal mission_selected(mission_id: String)
signal vehicle_selected(vehicle_index: int)
signal driver_selected(driver_index: int)

@onready var money_label: Label = $TopLeftPanel/MoneyLabel
@onready var reputation_label: Label = $TopLeftPanel/ReputationLabel
@onready var notification_label: Label = $NotificationLabel
@onready var missions_list: VBoxContainer = $MissionsList

var mission_map: Dictionary = {} # mission_id -> Mission
var vehicle_selector_panel: Panel = null
var driver_selector_panel: Panel = null

func _ready() -> void:
	notification_label.text = "UI lista"
	_create_vehicle_selector_ui()
	_create_driver_selector_ui()

## Crea programáticamente el panel y layout para el selector de vehículos.
func _create_vehicle_selector_ui() -> void:
	# Crear panel flotante para seleccionar vehiculos
	vehicle_selector_panel = Panel.new()
	vehicle_selector_panel.visible = false
	vehicle_selector_panel.size = Vector2(300, 400)
	# Centrar mas o menos
	vehicle_selector_panel.position = Vector2(400, 100) 
	add_child(vehicle_selector_panel)
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vehicle_selector_panel.add_child(vbox)
	
	var label = Label.new()
	label.text = "Selecciona un Vehículo"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

## Crea programáticamente el panel y layout para el selector de conductores.
func _create_driver_selector_ui() -> void:
	driver_selector_panel = Panel.new()
	driver_selector_panel.visible = false
	driver_selector_panel.size = Vector2(300, 400)
	driver_selector_panel.position = Vector2(720, 100) 
	add_child(driver_selector_panel)
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	driver_selector_panel.add_child(vbox)
	
	var label = Label.new()
	label.text = "Selecciona un Conductor"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

func update_money(money: int) -> void:
	money_label.text = "Dinero: $" + str(money)

func update_reputation(rep: float) -> void:
	reputation_label.text = "Reputación: " + str(rep)

## Crea un botón dinámico para una nueva misión en la lista de UI.
func add_mission_to_list(mission: Mission) -> void:
	if mission == null: return

	mission_map[mission.id] = mission

	var button: Button = Button.new()
	var type_str = "Std"
	if "type" in mission:
		type_str = str(mission.type) # Idealmente traducir enum a texto, ahora usa índice
	
	button.text = "%s | $%d | %s" % [mission.name, mission.reward, type_str]
	# Conectar pasando argumentos extras (bind)
	button.pressed.connect(Callable(self, "_on_mission_button_pressed").bind(mission.id))
	missions_list.add_child(button)

## Limpia todos los botones de la lista de misiones.
func clear_missions_list() -> void:
	for child in missions_list.get_children():
		child.queue_free()
	mission_map.clear()

## Muestra un mensaje de resultado (éxito/fracaso) en el área de notificaciones.
func show_mission_result(mission: Mission, success: bool, result: Dictionary) -> void:
	if mission == null: return

	var msg = ""
	if success:
		msg = "Misión %s completada. Ganancia: $%d\n%s" % [mission.name, int(result.get("gain", 0)), result.get("message", "")]
	else:
		msg = "Misión %s falló. Evento: %s\n%s" % [mission.name, str(result.get("event", "")), result.get("message", "")]
		
	notification_label.text = msg

func show_notification(text: String) -> void:
	notification_label.text = text

func _on_mission_button_pressed(mission_id: String) -> void:
	emit_signal("mission_selected", mission_id)

## Muestra el panel selector de vehículos, re-generando los botones según estado actual de la flota.
func show_vehicle_selector(fleet: Array) -> void:
	if not vehicle_selector_panel: return
	
	vehicle_selector_panel.visible = true
	var vbox = vehicle_selector_panel.get_node("VBox")
	# Limpiar botones anteriores (hijos > 0, el 0 es el label)
	for i in range(1, vbox.get_child_count()):
		vbox.get_child(i).queue_free()
		
	for i in range(fleet.size()):
		var veh = fleet[i]
		var btn = Button.new()
		
		# Intentar obtener nombre legible del tipo
		var type_name = "Vehículo"
		if "type" in veh:
			match veh.type:
				0: type_name = "Moto"
				1: type_name = "Van"
				2: type_name = "Camión"
		
		var status = "Disponible"
		if veh.on_mission: status = "Ocupado"
		
		btn.text = "%s - %s" % [type_name, status]
		if veh.on_mission:
			btn.disabled = true
			
		btn.pressed.connect(func():
			vehicle_selector_panel.visible = false
			emit_signal("vehicle_selected", i)
		)
		vbox.add_child(btn)

func hide_vehicle_selector() -> void:
	if vehicle_selector_panel:
		vehicle_selector_panel.visible = false

## Muestra el panel selector de conductores
func show_driver_selector(staff: Array) -> void:
	if not driver_selector_panel: return
	
	driver_selector_panel.visible = true
	var vbox = driver_selector_panel.get_node("VBox")
	for i in range(1, vbox.get_child_count()):
		vbox.get_child(i).queue_free()
		
	for i in range(staff.size()):
		var driver = staff[i]
		var btn = Button.new()
		
		var status_txt = "Disponible"
		if driver.status != 0: # IDLE
			status_txt = "Ocupado"
			
		btn.text = "%s [S:%.1f] - %s" % [driver.name, driver.driving_skill, status_txt]
		if driver.status != 0:
			btn.disabled = true
			
		btn.pressed.connect(func():
			driver_selector_panel.visible = false
			emit_signal("driver_selected", i)
		)
		vbox.add_child(btn)

