extends Node
class_name InteractiveMusicManager

enum MusicState {
	INTRO,
	SELECTION,
	BUILDUP,
	FIGHT
}

enum TransitionType {
	CHANGE_AT_BEAT,
	CROSSFADE_UNTIL_BEAT
}

@export var audio_player: AudioStreamPlayer
@export var state_data: Dictionary[MusicState, MusicStateConfig] = {}

var current_state: MusicStateConfig
var target_state: MusicStateConfig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player.finished.connect(_on_audio_player_finished)
	
	current_state = _get_state_config(MusicState.INTRO)
	_refresh_state()

func transition_to_state(state: MusicState) -> void:
	target_state = _get_state_config(state)
	
	var playback_time: float = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()
	
	var current_beat: int = int(playback_time * (current_state.bpm / 60))
	var sync_step_duration: float = current_state.transition_beat_every * (60 / current_state.bpm)
	
	@warning_ignore("integer_division")
	var sync_step: int = int(current_beat / current_state.transition_beat_every) + 1
	var time_until_sync_step: float = sync_step * sync_step_duration - playback_time
	
	var timer = get_tree().create_timer(time_until_sync_step)
	timer.timeout.connect(_on_transition_ready)

func _get_state_config(state: MusicState) -> MusicStateConfig:
	return state_data[state]

func _refresh_state() -> void:
	audio_player.stream = current_state.stream
	audio_player.play()

func _on_audio_player_finished() -> void:
	if(current_state.auto_transition):
		var current_state_type: MusicState = current_state.auto_transition_to
		current_state = _get_state_config(current_state_type)
		audio_player.stream = current_state.stream
	audio_player.play()

func _on_transition_ready() -> void:
	current_state = target_state
	_refresh_state()


# Concrete transition triggers
func _on_evolution_select_evolution_selected(evolution: Variant) -> void:
	transition_to_state(MusicState.BUILDUP)
