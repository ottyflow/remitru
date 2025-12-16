# Risky Routes (Project: Remitru)

**Risky Routes** es un juego de estrategia y gestión logística low-poly donde el jugador administra una flota de vehículos para completar misiones de transporte en una ciudad. El objetivo es equilibrar las ganancias económicas con los riesgos operativos (robos, accidentes, multas), manteniendo la reputación de la empresa.

> **Nota:** Este proyecto está en desarrollo activo. El nombre provisional es "Risky Routes".

## Características Principales

### Gestión de Flota
Administra diversos tipos de vehículos, cada uno con sus propias características:
- **Motos:** Rápidas y ágiles, ideales para entregas pequeñas.
- **Vans:** Balanceadas para carga media.
- **Camiones:** Alta capacidad de carga pero mayor costo operativo.

### Sistema de Misiones
El núcleo del juego gira en torno a aceptar y completar contratos. Los tipos de misión incluyen:
- **Reparto Estándar (Delivery):** Bajo riesgo, paga moderada.
- **Rutas Múltiples:** Mayor complejidad y recompensa.
- **Urgentes:** Alto riesgo de multas pero pagos elevados.
- **Traslado de Pasajeros:** Requiere vehículos específicos.

### Sistema de Riesgo
Cada misión tiene un nivel de riesgo asociado (Bajo, Medio, Alto) y un tipo de evento potencial (Robo, Accidente, Multa, Retraso). El resultado de la misión se calcula probabilísticamente:
- **Éxito:** Se cobra la recompensa y sube la reputación.
- **Fallo:** Se incurre en costos (reparaciones, multas, pérdida de carga) y baja la reputación.

### Sistema de Personal (Nuevo)
Ahora es necesario asignar conductores a los vehículos para las misiones.
- **Conductores:** Tienen atributos como Habilidad de Conducción (que reduce el riesgo) y Tolerancia al Estrés.
- **Experiencia:** Ganan XP con cada misión completada.

### Sistema de Mantenimiento (Nuevo)
Los vehículos sufren desgaste con el uso.
- **Desgaste:** Cada misión reduce la condición del vehículo.
- **Penalización:** Si el mantenimiento baja del 50%, aumenta drásticamente la probabilidad de roturas o accidentes.
- **Reparación:** Se puede reparar la flota en el garaje pagando un coste proporcional al daño.

## Estructura del Proyecto

El código fuente principal se encuentra en la carpeta `scripts/`. Los componentes clave son:

- **`main.gd`**: Controlador principal. Inicializa el juego, gestiona la flota y coordina la UI con el MissionManager.
- **`mission_manager.gd`**: Cerebro lógico. Genera misiones aleatorias y resuelve los resultados basándose en probabilidades de riesgo.
- **`vehicle.gd`**: Lógica de las entidades físicas. Controla el movimiento y pathfinding simple de los vehículos en el mapa 3D.
- **`ui.gd`**: Manejo de la interfaz. Muestra el listado de misiones, notificaciones y el selector de vehículos.
- **`mission.gd`**: Recurso de datos (Data Class) que define la estructura de una misión.
- **`driver.gd`**: Clase que representa a los conductores contratables.

## Requisitos

- **Motor:** Godot Engine 4.x
- **Lenguaje:** GDScript

## Instalación y Ejecución

1. Clonar este repositorio.
2. Importar el proyecto (`project.godot`) en Godot Engine.
3. Ejecutar la escena principal (`main.tscn` o similar).

## Estado del Proyecto

Actualmente en fase de prototipo (MVP). Se han implementado los sistemas base de:
- Generación de misiones.
- Asignación de vehículos.
- Cálculo de resultados y economía básica.
- Movimiento básico en el mundo.

---
*Documentación generada automáticamente basada en GDD v0.1.*
