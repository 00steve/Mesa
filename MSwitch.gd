extends "iface/MesaSpatial.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_press_button;
signal end_press_button;
signal m_switch;
var hia;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func ConnectActor(actor):
	pass;
	
func DisconnectActor(actor):
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func StartPressingButton(player):
	print("button: start pressing button");
	$Area.emit_signal("input_event");
	#InteractionArea().emit_signal("m_switch",1);

func EndPressingButton(player):
	print("button: stop pressing button");
	#InteractionArea().emit_signal("m_switch",0);


