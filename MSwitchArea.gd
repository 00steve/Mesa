extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_interacting;
signal end_interacting;
signal start_press_button;
signal end_press_button;
signal light_control;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"signalStartInteracting");
	self.connect("body_exited",self,"signalEndInteracting");

	
func startPressingButton(area):
	print("start pressing button");
	emit_signal("light_control",1);

func endPressingButton(area):
	print("stop pressing button");
	emit_signal("light_control",0);

func signalStartInteracting(area):
	print("start interacting probably");
	emit_signal("start_interacting",self);

func signalEndInteracting(area):
	print("end interacting probably");
	emit_signal("end_interacting",self);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
