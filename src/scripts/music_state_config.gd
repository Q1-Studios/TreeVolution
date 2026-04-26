extends Resource
class_name MusicStateConfig

@export var stream: AudioStream
@export var loop: bool = false
@export var bpm: float = 120
@export var transition_beat_every: int = 4

@export_group("Auto Transition")
@export var auto_transition: bool = false
@export var auto_transition_to: InteractiveMusicManager.MusicState
