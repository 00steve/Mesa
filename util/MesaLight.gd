extends OmniLight
class_name MesaLight

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on = false;
var lightNode = null;

var rand = RandomNumberGenerator.new()

func _init(omniLightNode):
	lightNode = omniLightNode;
	self.add_child(lightNode);
	rand.randomize();
	lightNode.set_color(Color(rand.randfn(0,1),rand.randfn(0,1),rand.randfn(0,1),1));
	

func Interaction(player):
	print("player did something with the light");
	on = !on;
	if(on):
		lightNode.show();
	if(!on):
		lightNode.hide();
