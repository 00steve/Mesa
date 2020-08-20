extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#the ladders node is the container that should be used to hold any ladders.
#it tells the ladeers which objects in the game to respond to.
# Called when the node enters the scene tree for the first time.
func _ready():
	var playerBody = self.get_parent().get_parent().get_node("Player");
	#loop through each of the ladders in the ladder group
	var count = 0;
	var area;
	for node in self.get_parent().get_node("Ladders").get_children():
		area = node.get_node("LadderArea");
		area.connect("start_climbing",playerBody,"StartClimbing");
		area.connect("end_climbing",playerBody,"EndClimbing");

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
