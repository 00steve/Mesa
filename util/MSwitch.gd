extends "../iface/MesaSpatial.gd"
class_name MSwitch

onready var Interaction = preload("res://util/Interaction.gd");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_press_button;
signal end_press_button;
signal system_event;
var hia;
var bzpos;
var bzpush;
var switchNode;

func _init(newSwitchNode):
	print("initialize new MSwitch");
	switchNode = newSwitchNode;
	#var area = MSwitchArea.new();
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	pass;
	#bzpos = $MSwitchCase/MSwitchButton.translation.z;
	#bzpush = 0;


func OnInput(actor):
	var pressed = Input.is_action_pressed("move_interact");
	var i = MesaInteraction.new();
	i.actor = actor;
	i.inputType = MesaInteraction.InputType.MSwitch;
	if pressed:
		i.inputValue = MesaInteraction.InputMSwitchValue.Push;
		bzpush = .01;
	else:
		i.inputValue = MesaInteraction.InputMSwitchValue.Release;
		bzpush = 0;
	print(i.inputValue);
	#$MSwitchCase/MSwitchButton.translation.z = bzpos - bzpush;
		
		
	emit_signal("system_event",i);


