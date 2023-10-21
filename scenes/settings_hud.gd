extends  Control

var sfx_volume: float
var music_volume: float

@export var parent_node: HUD

func _ready():
	sfx_volume = parent_node.load_from_disc("sfx_volume")
	music_volume = parent_node.load_from_disc("music_volume")
	
	$SfxControls/SfxSlider.value = sfx_volume
	$MusicControls/MusicSlider.value = music_volume

func _on_back_button_toggled(button_pressed):
	parent_node._on_settings_button_toggled(true)

func _on_sfx_slider_value_changed(value):
	var bus = AudioServer.get_bus_index("Sound Effects")
	AudioServer.set_bus_volume_db(bus, value)
	AudioServer.set_bus_mute(bus, value < -30)
	$SfxControls/SfxMuteButton.toggled.emit(value < -30)
	sfx_volume = value
	parent_node.save_to_disc(sfx_volume, "sfx_volume")
	

func _on_sfx_mute_button_toggled(button_pressed):
	var bus = AudioServer.get_bus_index("Sound Effects")
	AudioServer.set_bus_mute(bus, button_pressed)


func _on_music_slider_value_changed(value):
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, value)
	AudioServer.set_bus_mute(bus, value < -30)
	$MusicControls/MusicMuteButton.toggled.emit(value < -30)
	music_volume = value
	parent_node.save_to_disc(music_volume, "music_volume")


func _on_music_mute_button_toggled(button_pressed):
	var bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus, button_pressed)
