@tool
extends RichTextEffect
class_name RichTextNixieFlicker

# Defines the BBCode tag: [nixie]
var bbcode = "nixie"

# --- CONSTANT SUBTLE FLICKER ---
@export_group("Constant Subtle Flicker")
@export var enabled: bool = true
@export_range(1.0, 50.0, 0.5) var speed: float = 18.0
@export_range(0.0, 1.0, 0.05) var min_brightness: float = 0.8
@export_range(0.0, 1.0, 0.05) var max_brightness: float = 1.0

# --- BIG SPORADIC FLICKER ---
@export_group("Big Sporadic Flicker")
@export var enable_big_flicker: bool = true
@export_range(0.0, 1.0, 0.05) var big_flicker_chance: float = 0.2
@export_range(0.1, 5.0, 0.1) var big_flicker_frequency: float = 1.2
@export_range(0.0, 1.0, 0.05) var big_flicker_min_brightness: float = 0.1

# --- COOLDOWN / PAUSE INTERVAL ---
@export_subgroup("Cooldown Interval")
@export var enable_cooldown: bool = false
@export_range(1, 10, 1) var max_flicker_bursts: int = 3
@export_range(0.5, 30.0, 0.5) var cooldown_duration: float = 4.0

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if not enabled:
		return true

	# 1. Base Constant Subtle Flicker Calculation
	var time = char_fx.elapsed_time * speed
	var offset = float(char_fx.relative_index) * 12.34
	var noise = (sin(time + offset) + sin((time + offset) * 1.73) + sin((time + offset) * 0.45)) / 3.0
	var brightness = lerp(min_brightness, max_brightness, (noise + 1.0) / 2.0)

	# 2. Big Sporadic Voltage Dip Calculation
	if enable_big_flicker and big_flicker_chance > 0.0:
		var can_flicker = true
		
		# Optional Cooldown Check
		if enable_cooldown:
			var active_duration = float(max_flicker_bursts) / max(big_flicker_frequency, 0.001)
			var cycle_time = active_duration + cooldown_duration
			var current_cycle_time = fmod(char_fx.elapsed_time, cycle_time)
			
			if current_cycle_time > active_duration:
				can_flicker = false
		
		if can_flicker:
			var time_slot = int(char_fx.elapsed_time * big_flicker_frequency)
			var roll = fmod(abs(sin(float(char_fx.relative_index) * 12.9898 + float(time_slot) * 78.233) * 43758.5453), 1.0)
			
			if roll < big_flicker_chance:
				var window_progress = fmod(char_fx.elapsed_time * big_flicker_frequency, 1.0)
				var drop_envelope = sin(window_progress * PI)
				var stutter = (sin(char_fx.elapsed_time * 50.0 + float(char_fx.relative_index) * 7.0) + 1.0) / 2.0
				var dip_depth = lerp(big_flicker_min_brightness, min_brightness, stutter * 0.4)
				
				brightness = lerp(brightness, dip_depth, drop_envelope)

	# 3. Apply Multiplier Directly to Color
	# (Modulating char_fx.color applies to BOTH glyph fill and font outline automatically)
	char_fx.color.r *= brightness
	char_fx.color.g *= brightness
	char_fx.color.b *= brightness

	return true
