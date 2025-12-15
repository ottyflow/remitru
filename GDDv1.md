GDD v0.1 completo

1. Información General
Nombre provisional: Risky Routes (placeholder, se puede cambiar)
Género: Estrategia / Tycoon de logística y transporte
Vista: Isométrica 3D, low-poly
Plataforma objetivo: PC (con posibilidad futura de Web / Mobile)
Modelo de juego: Single player, partidas tipo “sandbox + misiones”
Elevator Pitch
Construís y gestionás tu propia empresa de transportes en una ciudad low-poly.
Cada misión de reparto, traslado o entrega genera dinero, pero también conlleva distintos niveles de riesgo: robos, accidentes, multas, retrasos, clima, etc.
Tu objetivo es equilibrar ganancias, riesgo y reputación para crecer sin quebrar.
Fantasía central
“Ser el cerebro detrás de una red de logística urbana, tomando decisiones frías con información incompleta, apostando a misiones arriesgadas para acelerar tu crecimiento… o arruinarlo todo.”

2. Pilares de Diseño
Decisiones con riesgo calculado
El jugador siempre ve el riesgo aproximado de una misión (bajo/medio/alto) y posibles consecuencias, pero nunca la certeza total.
Gestión, no acción directa
El jugador no maneja vehículos; se centra en asignar recursos, planificar rutas y gestionar gente.
Crecimiento progresivo de complejidad
Empezar con 1–2 vehículos y pocos barrios; terminar con una red compleja, múltiples tipos de misiones y sistemas avanzados.
Claridad visual low-poly
La estética es simple, colorida y limpia. Los elementos importantes se leen rápido en el mapa isométrico.

3. Mecánicas Principales
3.1 Loop principal de juego
Recibir lista de misiones disponibles.
Analizar recompensa, tiempo límite y nivel de riesgo de cada misión.
Asignar vehículos y conductores a las misiones.
Ver cómo se ejecutan en tiempo acelerado sobre el mapa (iconos moviéndose en el canvas isométrico).
Resolver eventos aleatorios de riesgo (decisiones rápidas / ventanas emergentes).
Cobrar recompensas, pagar gastos, reparar vehículos, gestionar personal.
Desbloquear mejoras, nuevos vehículos/zona de la ciudad.
Repetir.

3.2 Misiones
Tipos base de misión:
Reparto simple: entregar paquetes de A a B.
Ruta múltiple: varios puntos de entrega en una misma salida.
Traslado de pasajeros: llevar personas importantes de un punto a otro.
Carga frágil/especial: requiere vehículos o conductores con mejor nivel.
Misión urgente: alto pago, límite de tiempo muy estricto, riesgo elevado.
Atributos de misión:
Recompensa base ($)
Coste estimado (combustible, peajes)
Tiempo estimado
Nivel de riesgo: Bajo / Medio / Alto
Tipo de riesgo predominante:
Robo / vandalismo
Controles policiales / multas
Condiciones climáticas
Tráfico intenso / accidentes
Impacto en reputación (positivo/negativo)

3.3 Sistema de riesgo
Cada misión calcula una Probabilidad de evento según:
Zona de la ciudad (barrios más conflictivos vs seguros)
Hora del día
Clima
Estado del vehículo (mantenimiento)
Nivel del conductor / equipo asignado
Eventos posibles:
Robo parcial: se pierde % de la carga → menor pago.
Robo total / pérdida: fracaso de misión, pérdida total + penalización.
Multa: costo extra, pero se entrega a tiempo.
Accidente leve: retraso + coste de reparación.
Accidente grave: vehículo fuera de uso por X tiempo.
Atajo oportuno / ayuda externa: evento positivo (se reduce tiempo, bonus de reputación).
El jugador puede mitigar riesgos mediante:
Contratar seguridad (guardia, seguro extra).
Mejorar vehículos (blindaje, GPS, frenos).
Capacitar conductores.
Evitar determinadas zonas/horarios (cuando sea posible).

3.4 Gestión de recursos
Vehículos:
Tipos: moto, furgoneta, camión pequeño, camión grande, vehículo VIP.
Atributos:
Capacidad de carga
Velocidad
Consumo
Nivel de seguridad
Estado de mantenimiento (barra de durabilidad)
Personal:
Conductores con:
Nivel (XP)
Habilidad de conducción
Tolerancia al estrés
Conocimiento de la ciudad (reduce riesgo/tiempo)
Posibles roles de oficina:
Planificador de rutas (bonus de eficiencia)
Jefe de operaciones (reduce costos o riesgos globales)
Base / HQ:
Edificio principal en el mapa.
Slots de estacionamiento / depósito de vehículos.
Mejoras:
Taller propio → menor costo de reparación.
Centro de monitoreo → información más precisa del riesgo.
Oficina de contratos → misiones premium.

3.5 Economía
Ingresos:
Recompensas por misiones completadas.
Bonos de reputación (clientes VIP, contratos exclusivos).
Gastos:
Sueldos de personal.
Mantenimiento y reparaciones.
Combustible y peajes (según distancia/vehículo).
Seguros y seguridad adicional.
Multas / penalizaciones por fallos.
Objetivo económico:
No quebrar (si el balance es negativo sostenido, game over).
Alcanzar metas de campaña (por ejemplo: llegar a X dinero o reputación en Y días).

3.6 Progresión
Corto plazo:
Desbloqueo de nuevos barrios de la ciudad.
Mejora de vehículos y personal.
Aumento de reputación para acceder a misiones mejor pagas.
Mediano / largo plazo:
Nuevos tipos de contrato: logística para eventos, traslados VIP, servicios nocturnos.
Misiones encadenadas (campañas): serie de misiones con narrativa ligera.
Objetivos opcionales: “Expansión al puerto”, “Contrato con gran corporación”, etc.

4. Mundo y Niveles
4.1 Ciudad low-poly
Mapa isométrico dividido en distritos:
Centro (tráfico alto, buena paga)
Zona industrial (alto riesgo de accidentes, pagos medios)
Barrios residenciales (bajo riesgo, poco pago)
Zona puerto / aeropuerto (misiones de alto valor)
Cada distrito tiene:
Nivel de riesgo base
Densidad de tráfico
Tipos de misiones más frecuentes
4.2 Canvas del mapa
El juego se renderiza sobre un canvas isométrico 3D:
Tiles en grilla (calles, edificios, parques, agua).
Caminos predefinidos por los que se mueven los vehículos.
Capas:
Capa suelo (calles, veredas).
Capa edificios y props (árboles, postes, señales).
Capa vehículos / personajes.
Capa de overlays (rutas resaltadas, zonas de riesgo, clima).

5. Interfaz de Usuario (UI/UX)
5.1 Layout principal
Centro de pantalla:
Canvas con vista isométrica de la ciudad.
Panel lateral izquierdo:
Lista de misiones disponibles.
Filtros: por riesgo, por recompensa, por zona.
Panel lateral derecho:
Detalle de misión seleccionada.
Botones para asignar vehículo y conductor.
Info de riesgo, tiempo, recompensa neta estimada.
Header / barra superior:
Dinero actual.
Reputación.
Día/hora in-game.
Notificaciones rápidas.
Footer / barra inferior:
Atajos a:
Garaje de vehículos.
Empleados.
Mejoras de base.
Reportes (balance, estadísticas).
5.2 Flujo de usuario típico
Abre lista de misiones.
Hace click en una misión → se resalta la ruta en el mapa.
Elige vehículo y conductor desde el panel derecho.
Confirma → vehículo aparece en el mapa y empieza su recorrido.
Eventos emergentes aparecen como ventanas pequeñas sobre el canvas (elige respuesta).
Al finalizar, resumen de misión: ganancias, incidentes, cambios en reputación.

6. Estilo Visual y Audio
6.1 Arte
Low-poly colorido, formas simples.
Paleta con contrastes suaves, pero zonas peligrosas pueden tener colores más saturados o rojizos.
Edificios geométricos, pocos detalles pero formas claras para distinguir tipos de áreas.
6.2 Animaciones
Vehículos con animaciones simples de movimiento.
Partículas para:
Lluvia, niebla.
Incidentes (icono de choque, sirena policial, etc.).
Pequeñas animaciones UI al abrir paneles y completar misiones.
6.3 Audio
Música de fondo tranquila pero rítmica (sensación de “flujo de trabajo” constante).
Efectos:
Motor de vehículos.
Claxon en tráfico.
Sonidos de notificación para eventos de riesgo.
Fanfarrias suaves al completar misiones difíciles.

7. Aspectos Técnicos (alto nivel)
(Adaptable al motor que uses: Godot, Unity, Web/Canvas, etc.)
Motor gráfico:
3D low-poly con cámara fija isométrica.
Representación del mapa:
Grilla de nodos (para pathfinding).
Datos de cada tile (tipo, riesgo base, velocidad de tránsito).
Sistema de tiempo:
Reloj in-game que corre más rápido que el tiempo real.
Definición de “día laboral” para agrupar misiones.
IA básica:
Pathfinding de vehículos (A* sobre la grilla).
Sistema de eventos que dispara incidentes basados en probabilidad + modificadores.
Persistencia:
Guardado de partidas: dinero, reputación, vehículos, personal, mejoras desbloqueadas, estado de la ciudad.

8. Modo de Juego y Progresión Macro
8.1 Modo campaña
Serie de capítulos con objetivos claros:
“Arrancá tu empresa” (llegar a X dinero sin quebrar).
“Expandite al centro de la ciudad”.
“Obtené el contrato con la corporación X”.
8.2 Modo sandbox
Ciudad completa desbloqueada.
Objetivo libre: crecer tanto como quieras.
Posibilidad de ajustar sliders al inicio (más o menos riesgo global, economía más fácil/difícil).

9. Monetización (opcional / a definir)
Para PC/indie, lo más simple:
Compra única (premium) sin microtransacciones.
Eventual DLC con:
Nuevas ciudades (climas distintos: nieve, tormentas).
Nuevos tipos de vehículos (drones, barcos, tren ligero).
Eventos especiales de alto riesgo (protestas, apagones, etc.).

10. Alcance de un MVP
Para la primera versión jugable:
Un solo mapa de ciudad pequeña con 3 distritos.
3 tipos de vehículos (moto, furgón, camión pequeño).
5–6 tipos de misiones básicas.
Sistema de riesgo funcional con 3–4 eventos posibles.
Gestión básica de dinero, mantenimiento y sueldos.
UI mínima: lista de misiones, panel de asignación, indicadores principales (dinero, reputación, tiempo).
Con eso ya podés testear:
Si el loop de decisiones con riesgo se siente divertido.
Si la economía se entiende.
Si el mapa isométrico en canvas es claro.

