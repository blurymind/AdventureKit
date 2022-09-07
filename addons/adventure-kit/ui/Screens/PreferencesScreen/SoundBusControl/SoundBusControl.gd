extends VBoxContainer

export var default_volume := -30
export(String) var label := "Volume"
export(String) var bus_name := "Master"

var bus_id := 0
var volume := 0.0
var mute := false

func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)
	$VBox/Label.text = label
	mute = false

	AudioServer.set_bus_mute(bus_id, mute)
	$VBox/CheckButton.pressed = !mute
	$VBox/CheckButton.connect("toggled", self, "set_bus_on" )
	
	volume = default_volume
	
	var kit = Kit.get_audio_bus(bus_name)
	volume = kit.volume
	mute = kit.mute
	
	AudioServer.set_bus_volume_db(bus_id, volume)
	$Bar.value = volume
	
	$Bar.connect("value_changed", self, "set_bus_volume")
	connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed() -> void:
	if not visible:
		return
	
	volume = AudioServer.get_bus_volume_db(bus_id)
	$Bar.value = volume
	mute = AudioServer.is_bus_mute(bus_id)
	$VBox/CheckButton.pressed = !mute
	Kit.set_audio_bus(bus_name, volume, mute)
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"volume:", volume, "mute:", mute)

func set_bus_volume(value: int):
	AudioServer.set_bus_volume_db(bus_id, value)
	volume = value
	Kit.set_audio_bus(bus_name, volume, mute)
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"volume:", volume)

func set_bus_on(value: bool) -> void:
	mute = !value
	Kit.set_audio_bus(bus_name, volume, mute)
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"mute:", mute)
