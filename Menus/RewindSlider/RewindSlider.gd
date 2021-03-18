extends HBoxContainer


func _ready():
	#connect signals
	GSM.connect("rewind_speed_changed", self, "rewind_speed_changed")


func rewind_speed_changed(new_val):
	$HSlider.value = new_val


func _on_HSlider_value_changed(value):
	GVM.rewind_speed = value
	$Label2.text = str(value)
