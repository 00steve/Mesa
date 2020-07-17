extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	var playerBody = self.get_parent().get_node("Environment").get("playerBody");
	#loop through each of the ladders in the ladder group
	var count = 0;
	var area;
	for node in self.get_parent().get_node("Ladders").get_children():
		print("stuff");
		area = node.get_node("LadderArea");
		area.connect("start_climbing",playerBody,"startClimbing");
		area.connect("end_climbing",playerBody,"endClimbing");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func error(message):
	print("ERROR-LADDER [" + message + "]")
