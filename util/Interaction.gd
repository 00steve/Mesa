
class_name MesaInteraction

enum InputType {NA,MSwitch,LSwitch,Linear,Keyboard,Keypad};
enum InputNAValue {NA};
enum InputMSwitchValue {Push,Release};
enum InputLSwitchValue {In,Out};

var actor = null;
var inputType = InputType.NA;
var inputValue = null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
