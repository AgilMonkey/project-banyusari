extends Control


var dash_max_energy: float
var current_dash_energy: float
var dash_energy_req: float


@onready var energy_bar: ProgressBar = $EnergyBar


func _ready() -> void:
	energy_bar.max_value = dash_max_energy


func _process(delta: float) -> void:
	energy_bar.value = current_dash_energy
	
	if current_dash_energy < dash_energy_req:
		energy_bar.modulate = Color.DIM_GRAY
	else:
		energy_bar.modulate = Color.AQUA
