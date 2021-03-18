tool
extends HBoxContainer

#variables
export var bus_id = 0
export var slider_label = "Volume" setget set_slider_label


func _ready():
	#connect signals
	GSM.connect("bus_mute_changed", self, "bus_mute_changed")
	GSM.connect("bus_volume_changed", self, "bus_volume_changed")
	
	$MuteButton.bus_id = bus_id


func set_slider_label(new_val):
	slider_label = new_val
	
	if has_node("Label"):
		$Label.text = slider_label


func bus_mute_changed(new_bus_id, new_val):
	if bus_id == new_bus_id:
		$MuteButton.mute_button_pressed = new_val


func bus_volume_changed(new_bus_id, new_val):
	if bus_id == new_bus_id:
		$HSlider.value = new_val


func _on_MuteButton_mute_button_pressed(button_pressed):
	GSM.emit_signal("change_bus_mute", bus_id, button_pressed)


func _on_HSlider_value_changed(value):
	GSM.emit_signal("change_bus_volume", bus_id, value)
