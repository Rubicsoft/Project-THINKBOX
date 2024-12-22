extends Node3D


var audio_playlist: Dictionary = {
	"run" : $Run,
	"jump" : $Jump,
	"jump_ground" : $JumpGround,
	"player_voice" : $PlayerVoice
}


func play_audio(audio_name: String) -> void:
	var audio: AudioStreamPlayer3D = find_audio(audio_name)
	if audio is RandomAudioPlayback:
		audio.play_audio()
	else:
		audio.play()


func find_audio(audio_name):
	if audio_playlist.has(audio_name):
		if audio_playlist[audio_name] is AudioStreamPlayer3D:
			return audio_playlist[audio_name]
	else:
		printerr("Invalid Player audio input")
