extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_interacting;
signal end_interacting;

# Called when the node enters the scene tree for the first time.
func _ready():
	#look for any children with the type "Input"
	#look to see if they have an area.
	var playerBody = self.get_parent().get_parent().get_node("Environment").get("playerBody");
	#print(playerBody.get_name() + "light");
	#loop through each of the children of the light
	#look for any objects that start with "Input", to set them up to interact with the 
	#player, or any other NPCs that are capible of doing things and interacting with the world.
	var count = 0;
	var area;
	for input in self.get_children():
		if input.get_name() != "Input":
			continue;
		area = input.get_node("Area");
		if area == null:
			continue;
		print(area.get_class() + " is a light area");
		area.connect("start_interacting",playerBody,"startInteracting");
		area.connect("end_interacting",playerBody,"endInteracting");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
