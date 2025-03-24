extends Control


var current_dash_energy: float
var dash_energy_req: float


@onready var energy_bar: ProgressBar = $EnergyBar


func set_energy_bar_ui(dash_energy, dash_max, dash_req):
	current_dash_energy = dash_energy
	energy_bar.max_value = dash_max
	dash_energy_req = dash_req 


func _process(delta: float) -> void:
	energy_bar.value = current_dash_energy
	
	if current_dash_energy < dash_energy_req:
		energy_bar.modulate = Color.DIM_GRAY
	else:
		energy_bar.modulate = Color.AQUA
