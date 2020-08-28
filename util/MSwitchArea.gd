extends Area

signal start_interacting;
signal end_interacting;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[MSwitchArea is ready]");
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func SignalStartInteracting(area):
	print("start interacting probably");
	emit_signal("start_interacting",self);

func SignalEndInteracting(area):
	print("end interacting probably");
	emit_signal("end_interacting",self);


func StartPressingButton(player):
	print("player pressing action button");
