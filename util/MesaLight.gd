extends OmniLight
class_name MesaLight

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on = false;
var lightNode = null;


func _init(omniLightNode):
	lightNode = omniLightNode;
	print("setup MesaLight");
	#print(" - base class = " + lightNode.get_class());
	self.add_child(lightNode);
	lightNode.set_color(Color(1,0,0,1));
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func Interaction(player):
	print("player did something with the light");
	on = !on;
	if(on):
		show();
	if(!on):
		hide();
