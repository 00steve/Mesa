extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_climbing;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"start_climbing");



func start_climbing(area):
	print("ladder area");
	emit_signal("start_climbing",area);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
