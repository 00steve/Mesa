extends "../iface/MesaSpatial.gd"

class_name MSwitch

onready var Interaction = preload("res://util/Interaction.gd");
onready var MSwitchArea = preload("res://util/MSwitchArea.gd");

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
var buttonNode;

func _init(newComponent):
	switchNode = newComponent.ComponentNode;
	if(!switchNode):
		print("switchNode is invalid, FAIL!");
		return;
	self.set_name(newComponent.ComponentName + "Input");
	print("[system component " + self.get_name() + " is ready]");

	
func AddComponentPart(newComponent):
	print("MSwitch - add component part ");
	match newComponent.ComponentType:
		"Button":
			print("\t - child is Button");
			#switchNode.add_child(button_node);
		_:
			print("\t - child is unknown");
	#switchNode.add_child(newComponent.node);
	#.AddComponent(newComponent);

func Init():
	print("[init "  + self.get_name() + "]");
	var area = MSwitchArea.new();
	area.set_name("Area");
	#print(self.get_name() + " offset is " + String(switchNode.transform.origin.x) + "," + String(switchNode.transform.origin.y) + "," + String(switchNode.transform.origin.z));
	area.transform.origin = switchNode.transform.origin;
	self.add_child(area);


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;



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


