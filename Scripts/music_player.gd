extends AudioStreamPlayer

func _ready():
	playing = true 

func play_collect_sound():
	$CollectSoundPlayer.play()

func mute():
	playing = false
	$CollectSoundPlayer.volume_linear = 0

func unmute():
	playing = true
	$CollectSoundPlayer.volume_linear = 1.0
