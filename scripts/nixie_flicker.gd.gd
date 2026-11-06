@tool
extends RichTextEffect
class_name RichTextNixieFlicker

# Defines the BBCode tag: [nixie]
var bbcode = "nixie"

# --- COLOR & TARGET SETTINGS ---
@export_group("Color Settings")
@export var dim_target_color: Color = Color.BLACK

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

	# Safe type check guarantees a valid Color struct
	var target_col: Color = dim_target_color if dim_target_color is Color else Color.BLACK

	# Global engine uptime so timer NEVER resets
	var global_time: float = float(Time.get_ticks_msec()) / 1000.0

	# 1. Base Constant Subtle Flicker Calculation
	var time = global_time * speed
	var offset = float(char_fx.relative_index) * 12.34
	var noise = (sin(time + offset) + sin((time + offset) * 1.73) + sin((time + offset) * 0.45)) / 3.0
	var brightness = lerp(min_brightness, max_brightness, (noise + 1.0) / 2.0)

	# 2. Big Sporadic Voltage Dip Calculation
	if enable_big_flicker and big_flicker_chance > 0.0:
		var can_flicker = true
		
		# The global slot index increments based on frequency
		var global_slot = int(global_time * big_flicker_frequency)
		
		# Slot-based Cooldown logic (Flawlessly prevents mid-flicker cutoffs)
		if enable_cooldown:
			var slot_duration = 1.0 / max(big_flicker_frequency, 0.001)
			var cooldown_slots = max(1, int(round(cooldown_duration / slot_duration)))
			var cycle_slots = max_flicker_bursts + cooldown_slots
			var current_slot_in_cycle = global_slot % cycle_slots
			
			# If the current slot falls into the cooldown phase, block flickering
			if current_slot_in_cycle >= max_flicker_bursts:
				can_flicker = false
		
		if can_flicker:
			# Deterministic per-character roll based on the current global slot
			var roll = fmod(abs(sin(float(char_fx.relative_index) * 12.9898 + float(global_slot) * 78.233) * 43758.5453), 1.0)
			
			if roll < big_flicker_chance:
				# Progress within the current slot window (0.0 to 1.0)
				var window_progress = fmod(global_time * big_flicker_frequency, 1.0)
				
				# Smooth arc envelope
				var drop_envelope = sin(window_progress * PI)
				
				# Fast electrical stuttering noise during the drop
				var stutter = (sin(global_time * 50.0 + float(char_fx.relative_index) * 7.0) + 1.0) / 2.0
				var dip_depth = lerp(big_flicker_min_brightness, min_brightness, stutter * 0.4)
				
				brightness = lerp(brightness, dip_depth, drop_envelope)

	# 3. Blend from the active theme color toward the target color
	var original_alpha = char_fx.color.a
	char_fx.color = char_fx.color.lerp(target_col, 1.0 - brightness)
	char_fx.color.a = original_alpha

	return true
