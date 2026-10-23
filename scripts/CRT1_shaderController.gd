extends ColorRect

@export var game_viewport: SubViewport

@export_group("Phosphor Persistence")
@export_range(0.0, 5.0) var ghost_duration: float = 0.6
@export_range(0.0, 1.0) var ghost_threshold: float = 0.0
@export var ghost_gradient: GradientTexture1D

@export_group("CRT Mask Settings")
@export_range(0.1, 5.0) var mask_scale_multiplier: float = 1.0:
	set(val):
		mask_scale_multiplier = val
		_update_resolution_params() 

@export_group("Manual Degauss")
@export_range(0.1, 5.0) var degauss_duration: float = 1.2

@export_group("Power State")
@export var power_curve: Curve
@export_range(0.1, 5.0) var power_duration: float = 1.0

var vp_a: SubViewport
var vp_b: SubViewport
var rect_a: TextureRect
var rect_b: TextureRect
var ping_pong: bool = true
var accum_mat: ShaderMaterial

var _last_decay: float = -1.0
var _last_threshold: float = -1.0
var _last_gradient: GradientTexture1D = null
var _last_scale: float = -1.0

var is_powered_on: bool = true
var power_tween: Tween = null

func _ready() -> void:
	if material != null:
		material.resource_local_to_scene = true
		material.set_shader_parameter("degauss_progress", 1.0)
		material.set_shader_parameter("power_state", 1.0)

	var shader = Shader.new()
	shader.code = """
	shader_type canvas_item;
	render_mode blend_disabled; 

	uniform sampler2D current_frame : filter_nearest;
	uniform sampler2D ghost_gradient : filter_linear;
	uniform bool use_gradient = false;
	uniform float decay_rate = 0.05;
	uniform float threshold = 0.0;

	void fragment() {
		vec4 old_col = texture(TEXTURE, UV);
		vec4 new_col = texture(current_frame, UV);

		float new_energy = max(new_col.r, max(new_col.g, new_col.b));
		float decayed_energy = max(old_col.a - decay_rate, 0.0);

		if (decayed_energy > new_energy && decayed_energy > threshold) {
			vec3 final_rgb = use_gradient 
				? max(new_col.rgb, texture(ghost_gradient, vec2(1.0 - decayed_energy, 0.0)).rgb * decayed_energy)
				: max(new_col.rgb, old_col.rgb - vec3(decay_rate));
			
			COLOR = vec4(final_rgb, decayed_energy);
		} else {
			COLOR = vec4(new_col.rgb, new_energy);
		}
	}
	"""
	accum_mat = ShaderMaterial.new()
	accum_mat.shader = shader
	
	vp_a = SubViewport.new()
	vp_b = SubViewport.new()
	
	var initial_size = game_viewport.size if game_viewport != null and game_viewport.size.x > 0 else Vector2i(1, 1)
		
	for vp in [vp_a, vp_b]:
		vp.size = initial_size
		vp.transparent_bg = true
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		add_child(vp)

	rect_a = TextureRect.new()
	rect_b = TextureRect.new()
	
	for rect in [rect_a, rect_b]:
		rect.material = accum_mat
		rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		rect.set_anchors_preset(Control.PRESET_FULL_RECT)

	vp_a.add_child(rect_a)
	vp_b.add_child(rect_b)

	get_viewport().size_changed.connect(_update_resolution_params)
	_update_resolution_params()

	RenderingServer.frame_post_draw.connect(_on_frame_post_draw)

# --- INTEGRATED DEGAUSS HELPER ---
func trigger_degauss(duration_seconds: float = degauss_duration) -> void:
	if material != null:
		material.set_shader_parameter("degauss_progress", 0.0)
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_method(_update_degauss_uniform, 0.0, 1.0, duration_seconds)

func _update_degauss_uniform(val: float) -> void:
	if material != null:
		material.set_shader_parameter("degauss_progress", val)

# --- POWER STATE ANIMATION ---
func toggle_power() -> void:
	if power_tween and power_tween.is_running():
		power_tween.kill()
		
	is_powered_on = !is_powered_on
	power_tween = create_tween()
	
	# Tween a normalized progress value to sample the curve cleanly
	power_tween.tween_method(_apply_power_progress.bind(is_powered_on), 0.0, 1.0, power_duration)

func _apply_power_progress(progress: float, turning_on: bool) -> void:
	if material != null:
		var val = power_curve.sample(progress) if power_curve != null else progress
		if not turning_on:
			val = 1.0 - val
		material.set_shader_parameter("power_state", val)
# ---------------------------------

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			trigger_degauss()
		elif event.keycode == KEY_O:
			toggle_power()

func _update_resolution_params() -> void:
	if not is_inside_tree() or material == null:
		return
		
	var screen_size = get_viewport().get_visible_rect().size
	if screen_size.x <= 0.0 or screen_size.y <= 0.0:
		return
		
	var base_auto_scale = max(1.0, round(screen_size.y / 1080.0 * 10.0) / 10.0)
	var final_scale = base_auto_scale * mask_scale_multiplier

	if _last_scale != final_scale:
		material.set_shader_parameter("mask_scale", final_scale)
		_last_scale = final_scale

	var current_aspect = screen_size.y / screen_size.x
	material.set_shader_parameter("aspect", current_aspect)

func _on_frame_post_draw() -> void:
	if not is_inside_tree() or not is_instance_valid(game_viewport):
		return

	var current_size = game_viewport.size
	if current_size.x <= 0 or current_size.y <= 0:
		return
		
	if vp_a.size != current_size:
		vp_a.size = current_size
		vp_b.size = current_size

	var delta = get_process_delta_time()
	if delta <= 0.0:
		delta = 0.0166

	var live_frame = game_viewport.get_texture()

	if ghost_duration <= 0.0:
		if vp_a.render_target_update_mode != SubViewport.UPDATE_DISABLED:
			vp_a.render_target_update_mode = SubViewport.UPDATE_DISABLED
			vp_b.render_target_update_mode = SubViewport.UPDATE_DISABLED
		material.set_shader_parameter("tex", live_frame)
		return
	elif vp_a.render_target_update_mode == SubViewport.UPDATE_DISABLED:
		vp_a.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		vp_b.render_target_update_mode = SubViewport.UPDATE_ALWAYS

	var current_decay = (1.0 / ghost_duration) * delta

	if _last_decay != current_decay:
		accum_mat.set_shader_parameter("decay_rate", current_decay)
		_last_decay = current_decay

	if _last_threshold != ghost_threshold:
		accum_mat.set_shader_parameter("threshold", ghost_threshold)
		_last_threshold = ghost_threshold
		
	if _last_gradient != ghost_gradient:
		accum_mat.set_shader_parameter("use_gradient", ghost_gradient != null)
		if ghost_gradient != null:
			accum_mat.set_shader_parameter("ghost_gradient", ghost_gradient)
		_last_gradient = ghost_gradient

	accum_mat.set_shader_parameter("current_frame", live_frame)

	var active_vp = vp_a if ping_pong else vp_b
	var inactive_vp = vp_b if ping_pong else vp_a
	var target_rect = rect_a if ping_pong else rect_b
	
	target_rect.texture = inactive_vp.get_texture()
	material.set_shader_parameter("tex", active_vp.get_texture())
	
	ping_pong = !ping_pong
