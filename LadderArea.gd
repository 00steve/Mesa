extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_climbing;
signal end_climbing;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"signalStartClimbing");
	self.connect("body_exited",self,"signalEndClimbing");

func signalEndClimbing(area):
	emit_signal("end_climbing",area);
	
func signalStartClimbing(area):
	emit_signal("start_climbing",area);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
