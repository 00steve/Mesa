extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerNode;
var playerBody;

# Called when the node enters the scene tree for the first time.
func _ready():
	#get player objects
	playerNode = get_parent().get_parent().get_node("Player");
	if(!playerNode):
		print("Player node not found");
	playerBody = playerNode.get_node("PlayerBody");
	if(!playerBody):
		print("Player has no collision shape");
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
