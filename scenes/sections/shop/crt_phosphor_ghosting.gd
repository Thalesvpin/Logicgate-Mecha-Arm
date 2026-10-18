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

var _degauss_timer: float = -1.0

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

func _ready() -> void:
	if material != null:
		material.resource_local_to_scene = true
		material.set_shader_parameter("degauss_progress", 1.0)

	_degauss_timer = degauss_duration # Initialize at max so it doesn't trigger on boot

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

# --- NEW: IN-GAME TRIGGER ---
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			_degauss_timer = 0.0 # Resetting the timer fires the one-shot animation
# ----------------------------

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

	# --- SCRIPT-DRIVEN ONE-SHOT PROGRESSION ---
	if _degauss_timer < degauss_duration:
		_degauss_timer += delta
		if _degauss_timer >= degauss_duration:
			_degauss_timer = degauss_duration
			if material != null:
				material.set_shader_parameter("degauss_progress", 1.0)
		else:
			var progress = _degauss_timer / max(0.001, degauss_duration)
			if material != null:
				material.set_shader_parameter("degauss_progress", progress)
	# ------------------------------------------

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
