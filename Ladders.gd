extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	#get player objects
	var playerNode = get_parent().get_node("Player");
	if(!playerNode):
		error("Player node not found");
	var playerBody = playerNode.get_node("PlayerBody");
	if(!playerBody):
		error("Player has no collision shape");
		
	#loop through each of the ladders in the ladder group
	var count = 0;
	var area;
	for node in self.get_children():
		#if(node.get_node("area").is_type("Area")): 
		count += 1;
		area = node.get_node("LadderArea");
		#print(" - " + area.get_class());
		area.connect("start_climbing",playerBody,"climb");
		
	print("found " + count as String + " children");
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func error(message):
	print("ERROR-LADDER [" + message + "]")
