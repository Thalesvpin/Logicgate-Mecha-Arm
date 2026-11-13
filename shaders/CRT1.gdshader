shader_type canvas_item;

uniform sampler2D tex: filter_linear;

group_uniforms CRT_Geometry;
uniform float curve : hint_range(0.0, 0.5) = 0.0;
uniform float aspect : hint_range(0.5, 1.0) = 0.75;
uniform float bezel_shadow_strength : hint_range(0.0, 1.0) = 0.0;
uniform float bezel_shadow_width : hint_range(0.0, 0.5) = 0.1;

group_uniforms Glass_Reflection;
uniform bool use_glare = false;
uniform float glare_strength : hint_range(0.0, 1.0) = 0.2;
uniform vec2 glare_position = vec2(0.5, 0.5);
uniform float glare_rotation : hint_range(-3.14159, 3.14159) = 0.78539; 
uniform float glare_softness : hint_range(0.01, 2.0) = 0.5;
uniform float glare_size : hint_range(0.01, 2.0) = 0.2;

uniform bool use_glass_reflection = false;
uniform sampler2D glass_env_tex : hint_default_black, filter_linear_mipmap;
uniform float glass_env_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec2 glass_env_offset = vec2(0.0, 0.0);
uniform float glass_env_scale : hint_range(0.1, 10.0) = 1.0;
uniform float glass_blur : hint_range(0.0, 10.0) = 2.0; 
uniform float glass_curve : hint_range(0.0, 0.5) = 0.0;
uniform float glass_brightness : hint_range(0.0, 3.0) = 1.0;
uniform float glass_saturation : hint_range(0.0, 3.0) = 1.0;
uniform vec4 glass_tint : source_color = vec4(1.0);
uniform int glass_blend_mode : hint_enum("Add:0", "Screen:1", "Lighten:2") = 1;

group_uniforms Power_State;
uniform float power_state : hint_range(0.0, 1.0) = 1.0;
uniform int power_close_axis : hint_enum("Vertical:0", "Horizontal:1") = 0;
uniform vec4 power_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float power_flash_start : hint_range(0.0, 1.0) = 0.8;
uniform float power_flash_end : hint_range(0.0, 1.0) = 0.2;
uniform bool use_hum_bar = false;
uniform float hum_bar_strength : hint_range(0.0, 0.1) = 0.0;
uniform float hum_bar_speed : hint_range(0.0, 10.0) = 2.0;

group_uniforms Profiles;
uniform int crt_profile : hint_enum("Custom:0", "Arcade (Soft/Scanlined):1", "Consumer TV (Blurry/Bleed):2", "PVM (Sharp/Precise):3") = 0;

group_uniforms Mask;
uniform int mask_type : hint_enum(
	"Null:0", "Dots:1", "Aperture Grille:2", "Wide Grille:3", "Wide Soft Grille:4", "Slot Mask:5", "Fake Grouped:6", "Trinitron:7", "LCD Matrix:8", "Staggered Phosphor:9") = 6;
uniform float mask_scale : hint_range(0.1, 10.0, 0.1) = 1.0;
uniform float mask_brightness : hint_range(0.0, 1.0) = 1.0;
uniform bool animate_mask_brightness = false;
uniform sampler2D mask_brightness_curve;
uniform float mask_brightness_anim_speed = 1.0;
uniform float mask_brightness_anim_amplitude = 1.0;

group_uniforms Scanlines;
uniform bool use_scanlines = false;
uniform float scanline_count : hint_range(50.0, 2160.0) = 240.0;
uniform float scanline_brightness : hint_range(0.5, 1.0) = 1.0;
uniform float scanline_beam_width_min : hint_range(0.1, 1.0) = 0.25;
uniform float scanline_beam_width_max : hint_range(0.5, 3.0) = 1.0;
uniform float scanline_drift_speed : hint_range(-5.0, 5.0) = 0.0;
uniform float scanline_cutoff : hint_range(0.0, 1.0) = 0.0;

group_uniforms Scanlines.Artistic_Decoupling;
uniform bool use_decoupled_scanlines = false;
uniform bool decoupled_use_native_res = true;
uniform float decoupled_vertical_res : hint_range(50.0, 2160.0) = 480.0;
uniform bool decoupled_dynamic_thickness = true;
uniform float decoupled_beam_opacity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Interlaced_Flicker;
uniform float interlaced_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_interlaced = false;
uniform sampler2D interlaced_curve;
uniform float interlaced_anim_speed = 1.0;
uniform float interlaced_anim_amplitude = 1.0;
uniform float interlaced_fps : hint_range(1.0, 60.0) = 30.0;

group_uniforms Interleaved_Field_Processing;
uniform bool use_interleaved_fields = false;
uniform float field_bob_strength : hint_range(0.0, 1.0) = 0.5;
uniform float field_line_blanking : hint_range(0.0, 1.0) = 0.0;

group_uniforms Interlaced_Jitter;
uniform bool use_interlaced_jitter = false;
uniform float interlaced_jitter_strength : hint_range(0.0, 0.05) = 0.0;
uniform float interlaced_jitter_speed : hint_range(0.1, 20.0) = 10.0;
uniform float interlaced_jitter_frequency : hint_range(0.1, 5.0) = 1.5;
uniform bool interlaced_jitter_random = false;

group_uniforms V_Blanking_Roll;
uniform bool use_v_blanking = false;
uniform float v_blanking_speed : hint_range(0.0, 5.0) = 1.0;
uniform float v_blanking_bar_size : hint_range(0.0, 0.5) = 0.1;
uniform float v_blanking_tearing : hint_range(0.0, 1.0) = 0.2;

group_uniforms H_Sync_Loss;
uniform bool use_h_sync_loss = false;
uniform float h_sync_strength : hint_range(0.0, 1.0) = 0.15;
uniform float h_sync_frequency : hint_range(0.1, 10.0) = 3.0;
uniform float h_sync_speed : hint_range(0.0, 10.0) = 2.0;
uniform float h_sync_threshold : hint_range(0.0, 1.0) = 0.8;

group_uniforms Tape_Crease;
uniform bool use_tape_crease = false;
uniform float crease_speed : hint_range(0.0, 10.0) = 1.0;
uniform float crease_interval : hint_range(0.0, 20.0) = 3.0;
uniform float crease_width : hint_range(0.01, 0.2) = 0.04;
uniform float crease_noise_strength : hint_range(0.0, 2.0) = 1.0;

group_uniforms VHS_Head_Switching;
uniform bool use_head_switching = false;
uniform float head_switch_height : hint_range(0.01, 0.5) = 0.08;
uniform float head_switch_strength : hint_range(-0.1, 0.1) = 0.03;
uniform float head_switch_curve : hint_range(1.0, 5.0) = 1.5;
uniform bool head_switch_color_recovery = false;
uniform float head_switch_hue_twist : hint_range(-3.14159, 3.14159) = 1.2;
uniform float head_switch_sat_spike : hint_range(0.0, 2.0) = 0.65;

group_uniforms VHS_Edge_Wobble;
uniform bool use_edge_wobble = false;
uniform float edge_wobble_strength : hint_range(0.0, 0.1) = 0.005;
uniform float edge_wobble_scale : hint_range(0.1, 100.0) = 10.0;
uniform float edge_wobble_speed : hint_range(0.0, 10.0) = 2.0;

group_uniforms VHS_Tracking;
uniform bool use_vhs_tracking = false;
uniform float vhs_tracking_strength : hint_range(0.0, 1.0) = 0.0;
uniform float vhs_tracking_height : hint_range(0.01, 0.5) = 0.08;
uniform float vhs_tracking_speed : hint_range(-10.0, 10.0) = 2.0;
uniform float vhs_tracking_interval : hint_range(0.0, 10.0) = 2.0;
uniform float vhs_tracking_noise_scale : hint_range(1.0, 100.0) = 40.0;
uniform bool vhs_tracking_snow = false;
uniform float vhs_tracking_snow_strength : hint_range(0.0, 2.0) = 0.75;
uniform float vhs_tracking_snow_anisotropy : hint_range(0.0, 1.0) = 0.65;

group_uniforms VHS_Tape_Speed;
uniform bool use_vhs_tape_speed = false;
uniform int vhs_tape_speed_mode : hint_enum("SP (Standard):0", "LP (Long Play):1", "EP (Extended Play):2", "SLP (Super Long Play):3") = 0;
uniform float vhs_tape_speed_mix : hint_range(0.0, 1.0) = 1.0;

group_uniforms VHS_Deck_Sharpen;
uniform bool use_vhs_sharpen = false;
uniform float vhs_sharpen_strength : hint_range(0.0, 2.0) = 0.5;
uniform float vhs_sharpen_radius : hint_range(0.5, 4.0) = 1.5;

group_uniforms Composite_Bandwidth;
uniform bool use_bandwidth_scale = false;
uniform float bandwidth_scale : hint_range(0.25, 2.5) = 1.0;

group_uniforms Luma_Smear;
uniform bool use_luma_smear = false;
uniform float luma_smear_strength : hint_range(0.0, 1.0) = 0.4;
uniform float luma_smear_length : hint_range(1.0, 30.0) = 6.0;
uniform int luma_smear_filter : hint_enum("Constant-K (Smooth):0", "Butterworth (Ripple):1") = 0;

group_uniforms Chroma_Loss_Dropout;
uniform bool use_chroma_dropout = false;
uniform float chroma_dropout_rate : hint_range(0.0, 1.0) = 0.05;
uniform float chroma_dropout_strength : hint_range(0.0, 1.0) = 1.0;
uniform float chroma_dropout_speed : hint_range(0.0, 30.0) = 12.0;
uniform float chroma_dropout_drift_speed : hint_range(-10.0, 10.0) = 0.0;
uniform float chroma_dropout_line_scale : hint_range(0.05, 5.0) = 0.35;
uniform float chroma_dropout_patch_length : hint_range(0.1, 10.0) = 1.5;
uniform float chroma_dropout_softness : hint_range(0.001, 0.5) = 0.05;
uniform float chroma_dropout_static : hint_range(0.0, 1.0) = 0.25;
uniform int chroma_dropout_static_mode : hint_enum("Bipolar I/Q:0", "Monochrome Luma:1", "Warm/Cool Sparkle:2") = 0;
uniform float chroma_dropout_static_scale : hint_range(10.0, 500.0) = 120.0;

group_uniforms Chroma_Demodulation;
uniform bool use_chroma_demod = false;
uniform int chroma_demod_filter : hint_enum("Box:0", "Notch:1", "2D Adaptive Comb:2") = 2;
uniform float chroma_demod_strength : hint_range(0.0, 1.0) = 1.0;

group_uniforms Chroma_Phase_Error;
uniform bool use_chroma_phase_error = false;
uniform float chroma_phase_target_angle : hint_range(-3.14159, 3.14159) = 0.5;
uniform bool animate_chroma_phase_target = false;
uniform sampler2D chroma_phase_target_curve;
uniform float chroma_phase_target_anim_speed = 1.0;
uniform float chroma_phase_target_anim_amplitude = 3.14159;

uniform float chroma_phase_shift : hint_range(-3.14159, 3.14159) = 0.45;
uniform bool chroma_phase_shift_blend_mode = false;
uniform bool animate_chroma_phase_shift = false;
uniform sampler2D chroma_phase_shift_curve;
uniform float chroma_phase_shift_anim_speed = 1.0;
uniform float chroma_phase_shift_anim_amplitude = 1.57079;

uniform float chroma_phase_bleed : hint_range(0.0, 10.0) = 2.0;
uniform bool animate_chroma_phase_bleed = false;
uniform sampler2D chroma_phase_bleed_curve;
uniform float chroma_phase_bleed_anim_speed = 1.0;
uniform float chroma_phase_bleed_anim_amplitude = 2.0;

uniform float chroma_phase_selectivity : hint_range(0.5, 8.0) = 2.0;
uniform bool animate_chroma_phase_selectivity = false;
uniform sampler2D chroma_phase_selectivity_curve;
uniform float chroma_phase_selectivity_anim_speed = 1.0;
uniform float chroma_phase_selectivity_anim_amplitude = 2.0;

group_uniforms Scanline_Phase_Noise;
uniform bool use_scanline_phase_noise = false;
uniform float scanline_phase_noise_strength : hint_range(0.0, 3.14159) = 0.35;
uniform float scanline_phase_noise_speed : hint_range(0.0, 30.0) = 15.0;

group_uniforms Sharpness;
uniform float sharpness : hint_range(0.5, 1.0) = 0.6666666666666666666666666667;
uniform bool animate_sharpness = false;
uniform sampler2D sharpness_curve;
uniform float sharpness_anim_speed = 1.0;
uniform float sharpness_anim_amplitude = 1.0;

group_uniforms Composite_Sharpening;
uniform bool use_composite_sharpening = false;
uniform float composite_sharpening : hint_range(-1.0, 2.0) = 0.35;

group_uniforms Composite_Pre_Emphasis;
uniform bool use_pre_emphasis = false;
uniform float pre_emphasis_strength : hint_range(0.0, 2.0) = 0.35;
uniform float pre_emphasis_cutoff : hint_range(0.0, 1.0) = 0.1;

group_uniforms IRE_Pedestal_Clipping;
uniform bool use_analog_clipping = false;
uniform float analog_pedestal : hint_range(-0.5, 0.5) = 0.0;
uniform float analog_gain : hint_range(0.0, 5.0) = 1.0;

group_uniforms NTSC_Color_Bleed;
uniform bool use_yiq_bleed = false;
uniform int yiq_bleed_filter : hint_enum("Constant-K (Smooth):0", "Butterworth (Ripple):1") = 0;
uniform float yiq_bleed_spread : hint_range(0.1, 10.0) = 1.0;
uniform float yiq_chroma_offset : hint_range(-5.0, 5.0) = 0.0;
uniform bool use_vertical_chroma_smear = false;
uniform float chroma_smear_strength : hint_range(0.0, 1.0) = 1.0;
uniform float chroma_smear_scanlines : hint_range(0.1, 5.0) = 1.0;

group_uniforms YC_Delay;
uniform bool use_yc_delay = false;
uniform float yc_delay_amount : hint_range(0.0, 50.0) = 10.0;

group_uniforms VHS_Chroma_Noise;
uniform bool use_tape_noise = false;
uniform float tape_noise_strength : hint_range(0.0, 1.0) = 0.2;
uniform float tape_noise_scale : hint_range(0.01, 10.0) = 2.0;
uniform float tape_noise_speed : hint_range(0.0, 10.0) = 5.0;
uniform bool use_tape_noise_streak = false;
uniform float tape_noise_streak_detail : hint_range(0.0, 1.0) = 0.6;
uniform float tape_noise_streak_anisotropy : hint_range(0.0, 1.0) = 0.85;

group_uniforms Color_Killer;
uniform bool use_color_killer = false;
uniform float color_killer_threshold : hint_range(0.0, 1.0) = 0.3;

group_uniforms Cross_Color_Rainbowing;
uniform bool use_cross_color = false;
uniform float cross_color_strength : hint_range(0.0, 1.0) = 0.5;
uniform float cross_color_threshold : hint_range(0.0, 1.0) = 0.1;

group_uniforms Cross_Luminance;
uniform bool use_cross_luminance = false;
uniform float cross_luminance_strength : hint_range(0.0, 1.0) = 0.5;

group_uniforms Differential_Phase_Gain;
uniform bool use_dpg = false;
uniform float phase_shift : hint_range(-3.14159, 3.14159) = 0.0;
uniform float gain_multiplier : hint_range(0.0, 5.0) = 0.0;

group_uniforms Color_Burst_Phase_Drift;
uniform bool use_phase_drift = false;
uniform float phase_drift_strength : hint_range(0.0, 1.0) = 0.1;
uniform float phase_drift_speed : hint_range(0.0, 20.0) = 5.0;

group_uniforms Analog_Signal_Ringing;
uniform bool use_signal_ringing = false;
uniform float ringing_strength : hint_range(0.0, 1.0) = 0.2;
uniform float ringing_frequency : hint_range(1.0, 50.0) = 20.0;
uniform float ringing_decay : hint_range(0.1, 10.0) = 3.0;

group_uniforms Wobble;
uniform float wobble_strength : hint_range(0.0, 5.0) = 0.0;
uniform bool animate_wobble = false;
uniform sampler2D wobble_curve;
uniform float wobble_anim_speed = 1.0;
uniform float wobble_anim_amplitude = 1.0;

group_uniforms Rolling_Interference;
uniform float roll_strength : hint_range(0.0, 1.0) = 0.03;
uniform bool animate_roll = false;
uniform sampler2D roll_curve;
uniform float roll_anim_speed = 1.0;
uniform float roll_anim_amplitude = 1.0;
uniform float roll_size : hint_range(0.0, 100.0) = 15.0;
uniform float roll_speed : hint_range(-10.0, 10.0) = 2.0;

group_uniforms Sweep_Stripe;
uniform bool use_sweep_stripe = false;
uniform float stripe_width : hint_range(0.01, 1.0) = 0.15;
uniform float stripe_speed : hint_range(-5.0, 5.0) = 0.15;
uniform float stripe_interval : hint_range(0.1, 10.0) = 3.0;
uniform float stripe_offset : hint_range(0.0, 1.0) = 0.0;
uniform float stripe_angle : hint_range(0.0, 6.28318) = 0.0;
uniform int stripe_profile : hint_enum("Smoothstep:0", "Gaussian:1", "Exponential:2", "Cosine:3") = 0;
uniform float stripe_smoothness_lead : hint_range(0.0, 1.0) = 0.3;
uniform float stripe_smoothness_trail : hint_range(0.0, 1.0) = 0.3;

group_uniforms Sweep_Stripe.Hue;
uniform bool stripe_enable_hue = false;
uniform float stripe_hue_shift : hint_range(0.0, 6.28318) = 1.57;
uniform bool stripe_hue_oscillate = false;
uniform int stripe_hue_osc_profile : hint_enum("Sine:0", "Triangle:1", "Square:2", "Sawtooth:3") = 0;
uniform int stripe_hue_osc_axis : hint_enum("Off:0", "Horizontal:1", "Vertical:2") = 0;
uniform float stripe_hue_osc_min : hint_range(0.0, 6.28318) = 0.0;
uniform float stripe_hue_osc_max : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_hue_osc_scale : hint_range(0.1, 10.0) = 1.0;
uniform float stripe_hue_osc_freq : hint_range(0.1, 50.0) = 10.0;
uniform float stripe_hue_osc_speed : hint_range(-20.0, 20.0) = 5.0;
uniform float stripe_hue_osc_intensity : hint_range(0.0, 3.0) = 1.0;
uniform float stripe_hue_osc_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Sweep_Stripe.Secondary_Hue;
uniform bool stripe_enable_secondary_hue = false;
uniform float stripe_secondary_hue_shift : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_secondary_mix : hint_range(0.0, 1.0) = 0.5;
uniform bool stripe_secondary_wave_enabled = false;
uniform int stripe_secondary_wave_profile : hint_enum("Sine:0", "Triangle:1", "Square:2", "Sawtooth:3") = 0;
uniform int stripe_secondary_wave_axis : hint_enum("Horizontal:0", "Vertical:1") = 0;
uniform float stripe_secondary_wave_min : hint_range(0.0, 6.28318) = 0.0;
uniform float stripe_secondary_wave_max : hint_range(0.0, 6.28318) = 3.14159;
uniform float stripe_secondary_wave_scale : hint_range(0.1, 10.0) = 1.0;
uniform float stripe_secondary_wave_freq : hint_range(0.1, 50.0) = 10.0;
uniform float stripe_secondary_wave_speed : hint_range(-20.0, 20.0) = 8.0;
uniform float stripe_secondary_wave_intensity : hint_range(0.0, 3.0) = 1.0;
uniform float stripe_secondary_wave_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Sweep_Stripe.Saturation;
uniform bool stripe_enable_saturation = false;
uniform float stripe_saturation : hint_range(0.0, 3.0) = 1.2;

group_uniforms Sweep_Stripe.Brightness;
uniform bool stripe_enable_brightness = false;
uniform float stripe_brightness : hint_range(0.0, 3.0) = 1.1;

group_uniforms Sweep_Stripe.Contrast;
uniform bool stripe_enable_contrast = false;
uniform float stripe_contrast : hint_range(0.0, 3.0) = 1.1;

group_uniforms Multipath_Echo;
uniform bool use_echo = false;
uniform float echo_strength : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_echo_strength = false;
uniform sampler2D echo_strength_curve;
uniform float echo_strength_anim_speed = 1.0;
uniform float echo_strength_anim_interval : hint_range(0.0, 10.0) = 0.0;
uniform float echo_strength_anim_amplitude = 1.0;

uniform float echo_offset : hint_range(-0.05, 0.05) = 0.015;
uniform bool animate_echo_offset = false;
uniform sampler2D echo_offset_curve;
uniform float echo_offset_anim_speed = 1.0;
uniform float echo_offset_anim_interval : hint_range(0.0, 10.0) = 0.0;
uniform float echo_offset_anim_amplitude = 1.0;

group_uniforms Dot_Crawl;
uniform bool use_dot_crawl = false;
uniform float dot_crawl_strength : hint_range(0.0, 1.0) = 0.0;
uniform float dot_crawl_speed : hint_range(0.0, 20.0) = 15.0;
uniform float dot_crawl_threshold : hint_range(0.0, 1.0) = 0.1;

group_uniforms Signal_Loss_Glitch;
uniform float glitch_strength : hint_range(0.0, 1.0) = 0.0;
uniform float vsync_tearing : hint_range(0.0, 1.0) = 0.0;
uniform bool animate_glitch = false;
uniform sampler2D glitch_curve;
uniform float glitch_anim_speed = 1.0;
uniform float glitch_anim_amplitude = 1.0;
uniform float glitch_rate : hint_range(0.0, 1.0) = 0.05;
uniform float glitch_size : hint_range(0.01, 1.0) = 0.05;

group_uniforms Tape_Dropouts;
uniform bool use_tape_dropouts = false;
uniform float dropout_strength : hint_range(0.0, 1.0) = 1.0;
uniform float dropout_rate : hint_range(0.0, 0.2) = 0.02;
uniform float dropout_speed : hint_range(0.0, 50.0) = 20.0;
uniform float dropout_scale : hint_range(1.0, 1000.0) = 400.0;

group_uniforms Static_Noise;
uniform bool use_noise = false;
uniform float noise_strength : hint_range(0.0, 0.5) = 0.03;
uniform bool chroma_noise = false;
uniform bool animate_noise = false;
uniform sampler2D noise_curve;
uniform float noise_anim_speed = 1.0;
uniform float noise_anim_amplitude = 1.0;
uniform int noise_octaves : hint_range(1, 5) = 3;
uniform float noise_lacunarity : hint_range(0.1, 5.0) = 2.0;
uniform float noise_gain : hint_range(0.1, 1.0) = 0.5;
uniform float noise_base_scale : hint_range(0.1, 10.0) = 1.0;

group_uniforms Stylization_FX;
uniform bool use_gradient_map = false;
uniform sampler2D gradient_texture : hint_default_white;
uniform bool use_monochrome = false;
uniform vec4 monochrome_color : source_color = vec4(0.2, 1.0, 0.4, 1.0);
uniform bool use_color_quantization = false;
uniform float color_levels : hint_range(2.0, 64.0) = 16.0;
uniform bool use_auto_exposure = false;
uniform float exposure_threshold : hint_range(0.0, 1.0) = 0.7;
uniform float exposure_intensity : hint_range(0.0, 2.0) = 0.5;

group_uniforms Motion_Persistence;
uniform bool use_motion_persistence = false;
uniform sampler2D previous_frame_tex : hint_default_black;
uniform float persistence_strength : hint_range(0.0, 0.99) = 0.5;

group_uniforms Runtime_FX;
uniform sampler2D degauss_curve;
uniform float degauss_progress = 1.0; 

group_uniforms Manual_Degauss_Settings;
uniform float degauss_wobble_strength : hint_range(0.0, 500.0) = 250.0;
uniform float degauss_color_split : hint_range(0.0, 10.0) = 4.0;
uniform float degauss_bulge_strength : hint_range(0.0, 1.0) = 0.1;
uniform float degauss_tear_strength : hint_range(0.0, 1.0) = 0.2;
uniform float degauss_hue_shift_amount : hint_range(0.0, 6.28318) = 3.14159;
uniform float degauss_invert_strength : hint_range(0.0, 1.0) = 0.3;
uniform float degauss_ripple_strength : hint_range(0.0, 0.2) = 0.05;

group_uniforms;

varying flat vec4 v_tex_data;       // .xy = size, .zw = pixel_size
varying flat vec4 v_degauss_data;   // .x = wobble.x, .y = wobble.y, .z = bulge, .w = ripple
varying flat vec4 v_extra_data;     // .x = tear, .y = eff_scanlines, .z = phase_time, .w = hsync_time
varying flat vec4 v_vhs_speed_pack; // .x = luma_blur_px, .y = chroma_blur_px, .z = chroma_shift_px, .w = mix
varying flat vec4 v_phase_err_pack; // .xy = target_dir, .z = cos_shift, .w = sin_shift
varying flat vec4 v_phase_err_anim; // .x = eff_bleed, .y = eff_selectivity, .z = shift_blend_mult, .w = inv_bandwidth_scale

varying flat vec4 v_dyn_pack1; 
varying flat vec4 v_dyn_pack2; 
varying flat vec4 v_dyn_pack3; 
varying flat vec4 v_glitch_field; 
varying flat vec4 v_stripe_calc;
varying flat vec4 v_time_pack1; 
varying flat vec4 v_time_pack2; 
varying flat vec4 v_warp_power_pack;
varying flat vec4 v_glare_calc;
varying flat vec4 v_optim_pack; 
varying flat vec4 v_glass_env_pack;
varying flat vec4 v_glass_tint_pack;

const float INV_TAU = 0.15915494309189535;
const vec3 INV_GAMMA = vec3(0.4166666666666667);
const float TWO_THIRD_PI = 2.09439510239;
const vec3 PHASE_OFFSETS = vec3(0.0, 2.09439510239, 4.18879020479); 
const vec3 HUE_LUMA = vec3(0.299, 0.587, 0.114);
const vec3 HUE_V1 = vec3(0.701, -0.587, -0.114);
const vec3 HUE_V2 = vec3(-0.299, 0.413, -0.114);
const vec3 HUE_V3 = vec3(-0.299, -0.587, 0.886);
const vec3 HUE_U1 = vec3(0.168, 0.330, -0.497);
const vec3 HUE_U2 = vec3(0.328, -0.335, 0.007);
const vec3 HUE_U3 = vec3(-1.250, 1.050, 0.200);

const mat3 RGB_TO_YIQ = mat3(
	vec3(0.299, 0.5959, 0.2115),
	vec3(0.587, -0.2746, -0.5227),
	vec3(0.114, -0.3213, 0.3112)
);

const mat3 YIQ_TO_RGB = mat3(
	vec3(1.0, 1.0, 1.0),
	vec3(0.956, -0.272, -1.106),
	vec3(0.619, -0.647, 1.703)
);

void vertex() {
	vec2 base_tex_size = vec2(textureSize(tex, 0));
	v_tex_data.xy = base_tex_size;
	v_tex_data.zw = 1.0 / max(base_tex_size, vec2(0.0001));

	v_extra_data.y = scanline_count * (base_tex_size.y / max(base_tex_size.x * aspect, 0.0001));
	v_extra_data.z = TIME * phase_drift_speed;
	v_extra_data.w = TIME * h_sync_speed;

	float inv_bw = use_bandwidth_scale ? (1.0 / max(bandwidth_scale, 0.05)) : 1.0;

	if (use_vhs_tape_speed) {
		float l_spread = 0.4;
		float c_spread = 2.0;
		float c_shift = 0.5;
		if (vhs_tape_speed_mode == 1) { // LP
			l_spread = 0.9;
			c_spread = 3.8;
			c_shift = 1.1;
		} else if (vhs_tape_speed_mode == 2) { // EP
			l_spread = 1.5;
			c_spread = 6.0;
			c_shift = 1.8;
		} else if (vhs_tape_speed_mode == 3) { // SLP
			l_spread = 2.2;
			c_spread = 8.5;
			c_shift = 2.5;
		}
		v_vhs_speed_pack = vec4(l_spread * v_tex_data.z * inv_bw, c_spread * v_tex_data.z * inv_bw, c_shift * v_tex_data.z * inv_bw, vhs_tape_speed_mix);
	} else {
		v_vhs_speed_pack = vec4(0.0);
	}

	if (use_chroma_phase_error) {
		float eff_target = chroma_phase_target_angle;
		if (animate_chroma_phase_target) {
			eff_target += textureLod(chroma_phase_target_curve, vec2(fract(TIME * chroma_phase_target_anim_speed), 0.0), 0.0).r * chroma_phase_target_anim_amplitude;
		}
		
		float eff_shift = chroma_phase_shift;
		float shift_blend_mult = 1.0;
		if (chroma_phase_shift_blend_mode) {
			if (animate_chroma_phase_shift) {
				shift_blend_mult = clamp(textureLod(chroma_phase_shift_curve, vec2(fract(TIME * chroma_phase_shift_anim_speed), 0.0), 0.0).r * chroma_phase_shift_anim_amplitude, 0.0, 1.0);
			}
		} else {
			if (animate_chroma_phase_shift) {
				eff_shift += textureLod(chroma_phase_shift_curve, vec2(fract(TIME * chroma_phase_shift_anim_speed), 0.0), 0.0).r * chroma_phase_shift_anim_amplitude;
			}
		}

		float eff_bleed = chroma_phase_bleed;
		if (animate_chroma_phase_bleed) {
			eff_bleed += textureLod(chroma_phase_bleed_curve, vec2(fract(TIME * chroma_phase_bleed_anim_speed), 0.0), 0.0).r * chroma_phase_bleed_anim_amplitude;
		}
		float eff_selectivity = chroma_phase_selectivity;
		if (animate_chroma_phase_selectivity) {
			eff_selectivity += textureLod(chroma_phase_selectivity_curve, vec2(fract(TIME * chroma_phase_selectivity_anim_speed), 0.0), 0.0).r * chroma_phase_selectivity_anim_amplitude;
		}
		v_phase_err_pack = vec4(
			cos(eff_target),
			sin(eff_target),
			cos(eff_shift),
			sin(eff_shift)
		);
		v_phase_err_anim = vec4(max(0.0, eff_bleed), max(0.01, eff_selectivity), shift_blend_mult, inv_bw);
	} else {
		v_phase_err_pack = vec4(1.0, 0.0, 1.0, 0.0);
		v_phase_err_anim = vec4(0.0, 1.0, 1.0, inv_bw);
	}

	v_warp_power_pack.xy = vec2(1.0 / aspect, aspect);
	v_warp_power_pack.zw = (power_close_axis == 0) ? vec2(1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001), 1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001)) : vec2(1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001), 1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001));
	v_optim_pack.x = 0.0;
	
	if (power_state < 1.0) {
		float t = clamp((power_flash_start - power_state) / max(0.0001, power_flash_start - power_flash_end), 0.0, 1.0);
		v_optim_pack.x = t * t * (3.0 - 2.0 * t) * power_flash_color.a;
	}
	
	v_optim_pack.y = -1000.0; 
	if (use_vhs_tracking && abs(vhs_tracking_speed) > 0.001) {
		float travel_dist = 1.0 + vhs_tracking_height;
		float abs_speed = abs(vhs_tracking_speed);
		float sweep_time = travel_dist / abs_speed;
		float total_cycle = sweep_time + max(0.001, vhs_tracking_interval);
		float local_time = mod(TIME, total_cycle);
		if (local_time < sweep_time) {
			v_optim_pack.y = (vhs_tracking_speed > 0.0) ? (-vhs_tracking_height + local_time * abs_speed) : (1.0 - local_time * abs_speed);
		}
	}
	
	v_optim_pack.z = scanline_brightness;
	if (crt_profile == 1) v_optim_pack.z = 0.8;
	else if (crt_profile == 2) v_optim_pack.z = 0.4;
	
	v_optim_pack.w = TIME * interlaced_jitter_speed;
	
	v_glare_calc = vec4(cos(glare_rotation), sin(glare_rotation), 1.0 - bezel_shadow_width, glare_size + glare_softness);
	v_glass_env_pack = vec4(1.0 / max(0.001, glass_env_scale), 1.0 / max(0.001, glass_env_scale), 0.5 + glass_env_offset.x, 0.5 + glass_env_offset.y);
	v_glass_tint_pack = vec4(glass_tint.rgb * glass_brightness, glass_env_strength * glass_tint.a);

	float _degauss = 0.0;
	if (degauss_progress < 1.0) _degauss = textureLod(degauss_curve, vec2(degauss_progress, 0.0), 0.0).r;

	float _wobble = wobble_strength;
	if (animate_wobble) _wobble += textureLod(wobble_curve, vec2(fract(TIME * wobble_anim_speed), 0.0), 0.0).r * wobble_anim_amplitude;
	
	_wobble += _degauss * degauss_wobble_strength; 
	
	v_degauss_data.x = _degauss;
	v_degauss_data.y = cos(TIME * TAU * 15.0) * _wobble * 0.0001220703125;
	v_degauss_data.z = degauss_bulge_strength * v_degauss_data.x;
	v_degauss_data.w = degauss_ripple_strength * v_degauss_data.x;
	v_extra_data.x = degauss_tear_strength * v_degauss_data.x;

	v_dyn_pack1.x = 0.0; 
	if (_degauss > 0.0) v_dyn_pack1.x += _degauss * degauss_color_split;

	v_dyn_pack1.y = sharpness;
	if (animate_sharpness) v_dyn_pack1.y += textureLod(sharpness_curve, vec2(fract(TIME * sharpness_anim_speed), 0.0), 0.0).r * sharpness_anim_amplitude;
	if (crt_profile == 1) v_dyn_pack1.y = 0.8;
	else if (crt_profile == 2) v_dyn_pack1.y = 0.5;
	else if (crt_profile == 3) v_dyn_pack1.y = 1.0;

	v_dyn_pack1.z = mask_brightness;
	if (animate_mask_brightness) v_dyn_pack1.z += textureLod(mask_brightness_curve, vec2(fract(TIME * mask_brightness_anim_speed), 0.0), 0.0).r * mask_brightness_anim_amplitude;

	v_dyn_pack1.w = interlaced_strength;
	if (animate_interlaced) v_dyn_pack1.w += textureLod(interlaced_curve, vec2(fract(TIME * interlaced_anim_speed), 0.0), 0.0).r * interlaced_anim_amplitude;

	v_dyn_pack2.x = roll_strength;
	if (animate_roll) v_dyn_pack2.x += textureLod(roll_curve, vec2(fract(TIME * roll_anim_speed), 0.0), 0.0).r * roll_anim_amplitude;

	v_dyn_pack2.y = glitch_strength;
	if (animate_glitch) v_dyn_pack2.y += textureLod(glitch_curve, vec2(fract(TIME * glitch_anim_speed), 0.0), 0.0).r * glitch_anim_amplitude;

	v_dyn_pack2.z = use_noise ? noise_strength : 0.0;
	if (animate_noise && use_noise) v_dyn_pack2.z += textureLod(noise_curve, vec2(fract(TIME * noise_anim_speed), 0.0), 0.0).r * noise_anim_amplitude;

	v_dyn_pack3.x = use_echo ? echo_strength : 0.0;
	if (animate_echo_strength && use_echo) {
		if (echo_strength_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_strength_anim_speed);
			float total_time = active_time + echo_strength_anim_interval;
			float local_t = mod(TIME, total_time);
			if (local_t < active_time) v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(local_t * echo_strength_anim_speed, 0.0), 0.0).r * echo_strength_anim_amplitude;
		} else {
			v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(fract(TIME * echo_strength_anim_speed), 0.0), 0.0).r * echo_strength_anim_amplitude;
		}
	}

	v_dyn_pack3.y = echo_offset;
	if (animate_echo_offset) {
		if (echo_offset_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_offset_anim_speed);
			float total_time = active_time + echo_offset_anim_interval;
			float local_t = mod(TIME, total_time);
			if (local_t < active_time) v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(local_t * echo_offset_anim_speed, 0.0), 0.0).r * echo_offset_anim_amplitude;
		} else {
			v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(fract(TIME * echo_offset_anim_speed), 0.0), 0.0).r * echo_offset_anim_amplitude;
		}
	}
	
	v_dyn_pack3.z = TIME * stripe_hue_osc_speed;
	v_dyn_pack3.w = TIME * stripe_secondary_wave_speed;

	float glitch_time = floor(TIME * 20.0);
	float r1 = fract(sin(glitch_time * 91.2228) * 43758.5453);
	v_glitch_field.x = fract(sin(glitch_time * 50.481) * 43758.5453);
	v_glitch_field.y = step(1.0 - glitch_rate, r1) * (fract(sin(glitch_time * 125.391) * 43758.5453) - 0.5) * v_dyn_pack2.y;
	v_glitch_field.z = float(int(TIME * interlaced_fps) & 1); 
	v_glitch_field.w = TIME * 91.2228;

	v_time_pack1 = vec4(TIME * 60.0, TIME * 30.0, fract(TIME * 0.2), fract(TIME * 0.1));
	v_time_pack2 = vec4(TIME * dot_crawl_speed, TIME * roll_speed, TIME * 15.0, 1.0 / max(mask_scale, 0.01));

	if (use_sweep_stripe) {
		float margin = stripe_width * 1.5;
		v_stripe_calc.x = -margin + fract((TIME * stripe_speed) / stripe_interval + stripe_offset) * (1.0 + (margin * 2.0));
		v_stripe_calc.y = cos(stripe_angle);
		v_stripe_calc.z = sin(stripe_angle);
		v_stripe_calc.w = 1.0 / max(0.0001, stripe_width * 0.5);
	} else {
		v_stripe_calc = vec4(0.0);
	}
}

vec3 rgb_to_yiq(vec3 rgb) {
    return RGB_TO_YIQ * rgb;
}

vec3 yiq_to_rgb(vec3 yiq) {
    return clamp(YIQ_TO_RGB * yiq, 0.0, 1.0);
}

float hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

vec3 hash32(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz + 33.33);
	return fract((p3.xxy + p3.yzz) * p3.zyx);
}

float value_noise_1(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash12(i + vec2(0.0, 0.0)), hash12(i + vec2(1.0, 0.0)), u.x),
			   mix(hash12(i + vec2(0.0, 1.0)), hash12(i + vec2(1.0, 1.0)), u.x), u.y);
}

vec3 value_noise_3(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash32(i + vec2(0.0, 0.0)), hash32(i + vec2(1.0, 0.0)), u.x),
			   mix(hash32(i + vec2(0.0, 1.0)), hash32(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm_1(vec2 p, int octaves, float lacunarity, float gain) {
	float val = 0.0;
	float amp = 1.0;
	float norm = 0.0;
	for (int i = 0; i < 5; i++) {
		if (i >= octaves) break;
		val += amp * value_noise_1(p);
		norm += amp;
		p *= lacunarity;
		amp *= gain;
	}
	return val / norm;
}

vec3 fbm_3(vec2 p, int octaves, float lacunarity, float gain) {
	vec3 val = vec3(0.0);
	float amp = 1.0;
	float norm = 0.0;
	for (int i = 0; i < 5; i++) {
		if (i >= octaves) break;
		val += amp * value_noise_3(p);
		norm += amp;
		p *= lacunarity;
		amp *= gain;
	}
	return val / norm;
}

vec2 warp(vec2 uv) {
	uv -= 0.5;
	uv.x *= v_warp_power_pack.x;
	uv /= 1.0 - curve * (dot(uv, uv) - 0.25);
	uv.x *= v_warp_power_pack.y;
	uv += 0.5;
	
	return (uv - 0.5) * v_warp_power_pack.zw + 0.5;
}

vec3 linear_to_srgb(vec3 col) {
	return mix((pow(col, INV_GAMMA) * 1.055) - 0.055, col * 12.92, lessThan(col, vec3(0.0031318)));
}

vec3 srgb_to_linear(vec3 col) {
	return mix(pow((col + 0.055) * 0.947867298578, vec3(2.4)), col * 0.0773993808049, lessThan(col, vec3(0.04045)));
}

vec3 shift_hue(vec3 color, float shift) {
	float c = cos(shift);
	float s = sin(shift);
	vec3 col0 = HUE_LUMA + HUE_V1 * c + HUE_U1 * s;
	vec3 col1 = HUE_LUMA + HUE_V2 * c + HUE_U2 * s;
	vec3 col2 = HUE_LUMA + HUE_V3 * c + HUE_U3 * s;
	return clamp(vec3(dot(color, col0), dot(color, col1), dot(color, col2)), 0.0, 1.0);
}

float evaluate_wave(int profile, float pos) {
	if (profile == 0) return 0.5 + 0.5 * sin(pos);
	float f = fract(pos * INV_TAU);
	if (profile == 1) return abs(f - 0.5) * 2.0;
	if (profile == 2) return step(0.5, f);
	return f;
}

vec3 sample_row(int ix, int iy, vec3 wa, vec3 wb, vec3 wc, vec3 wd, vec3 we) {
	return srgb_to_linear(texelFetch(tex, ivec2(ix - 2, iy), 0).rgb) * wa +
	       srgb_to_linear(texelFetch(tex, ivec2(ix - 1, iy), 0).rgb) * wb +
	       srgb_to_linear(texelFetch(tex, ivec2(ix,     iy), 0).rgb) * wc +
	       srgb_to_linear(texelFetch(tex, ivec2(ix + 1, iy), 0).rgb) * wd +
	       srgb_to_linear(texelFetch(tex, ivec2(ix + 2, iy), 0).rgb) * we;
}

vec3 sample_image(vec2 uv, vec2 local_chroma_offset) {
	if (use_interleaved_fields && field_bob_strength > 0.0) {
		uv.y += (v_glitch_field.z - 0.5) * (field_bob_strength / max(v_extra_data.y, 1.0));
	}

	vec2 scaled_uv = uv * v_tex_data.xy;
	int ix = int(floor(scaled_uv.x));
	bool fast = (v_dyn_pack1.y >= 0.999 && v_dyn_pack1.x == 0.0 && local_chroma_offset == vec2(0.0));
	
	vec3 weight_a, weight_b, weight_c, weight_d, weight_e;
	vec3 weight_scaler_vec = vec3(0.0);
	
	if (!fast) {
		float diff_base = fract(scaled_uv.x) - 0.5; 
		vec3 diff = vec3(diff_base - (v_dyn_pack1.x + local_chroma_offset.x), diff_base, diff_base + (v_dyn_pack1.x + local_chroma_offset.y));
		weight_a = smoothstep(vec3(1.0), vec3(0.0), (diff + 2.0) * v_dyn_pack1.y);
		weight_b = smoothstep(vec3(1.0), vec3(0.0), (diff + 1.0) * v_dyn_pack1.y);
		weight_c = smoothstep(vec3(1.0), vec3(0.0), abs(diff) * v_dyn_pack1.y);
		weight_d = smoothstep(vec3(1.0), vec3(0.0), (1.0 - diff) * v_dyn_pack1.y);
		weight_e = smoothstep(vec3(1.0), vec3(0.0), (2.0 - diff) * v_dyn_pack1.y);
		weight_scaler_vec = 1.0 / (weight_a + weight_b + weight_c + weight_d + weight_e);
	}

	float abstract_y = uv.y * v_extra_data.y;
	vec3 result_color;

	if (use_scanlines) {
		float shifted_y = abstract_y - TIME * scanline_drift_speed;
		
		float y_center1 = floor(shifted_y) + 0.5;
		float diff = fract(shifted_y) - 0.5;
		float y_center2 = y_center1 + (diff < 0.0 ? -1.0 : 1.0);
		
		float dist1 = abs(shifted_y - y_center1); 
		float dist2 = abs(shifted_y - y_center2); 
		
		float fw = max(fwidth(shifted_y), 0.001);

		if (use_decoupled_scanlines) {
			float sample_res = decoupled_use_native_res ? v_tex_data.y : decoupled_vertical_res;
			float abstract_sample_y = uv.y * sample_res;
			float tex_y = (floor(abstract_sample_y) + 0.5) / sample_res * v_tex_data.y;
			int iy = clamp(int(floor(tex_y)), 0, int(v_tex_data.y) - 1);
			
			vec3 raw_color;
			if (fast) {
				raw_color = srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb);
			} else {
				raw_color = sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
			}
			
			vec3 col = raw_color * v_optim_pack.z;
			vec3 thick = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), decoupled_dynamic_thickness ? col : vec3(1.0));
			
			float blur = fw * 1.25;
			vec3 beam1 = smoothstep(thick * 0.5 + blur, thick * 0.5 - blur, vec3(dist1));
			vec3 beam2 = smoothstep(thick * 0.5 + blur, thick * 0.5 - blur, vec3(dist2));
			
			int field_glitch = int(v_glitch_field.z);
			beam1 *= 1.0 - float((int(y_center1) & 1) ^ field_glitch) * v_dyn_pack1.w;
			beam2 *= 1.0 - float((int(y_center2) & 1) ^ field_glitch) * v_dyn_pack1.w;
			
			vec3 final_lines = mix(raw_color, col * (beam1 + beam2), decoupled_beam_opacity);
			
			if (scanline_cutoff > 0.0) {
				float luma = dot(raw_color, vec3(0.333));
				result_color = mix(raw_color, final_lines, smoothstep(0.0, scanline_cutoff, luma));
			} else {
				result_color = final_lines;
			}
		} else {
			float tex_y1 = y_center1 + TIME * scanline_drift_speed;
			float tex_y2 = y_center2 + TIME * scanline_drift_speed;
			
			int iy1 = clamp(int(floor((tex_y1 / v_extra_data.y) * v_tex_data.y)), 0, int(v_tex_data.y) - 1);
			int iy2 = clamp(int(floor((tex_y2 / v_extra_data.y) * v_tex_data.y)), 0, int(v_tex_data.y) - 1);

			vec3 raw1, raw2;
			if (fast) {
				raw1 = srgb_to_linear(texelFetch(tex, ivec2(ix, iy1), 0).rgb);
				raw2 = srgb_to_linear(texelFetch(tex, ivec2(ix, iy2), 0).rgb);
			} else {
				raw1 = sample_row(ix, iy1, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
				raw2 = sample_row(ix, iy2, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
			}

			vec3 col1 = raw1 * v_optim_pack.z;
			vec3 col2 = raw2 * v_optim_pack.z;

			vec3 thick1 = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), col1);
			vec3 thick2 = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), col2);
			
			float blur = fw * 1.25; 
			vec3 profile1 = smoothstep(thick1 * 0.5 + blur, thick1 * 0.5 - blur, vec3(dist1)) * col1;
			vec3 profile2 = smoothstep(thick2 * 0.5 + blur, thick2 * 0.5 - blur, vec3(dist2)) * col2;
			
			int field_glitch = int(v_glitch_field.z);
			profile1 *= 1.0 - float((int(y_center1) & 1) ^ field_glitch) * v_dyn_pack1.w;
			profile2 *= 1.0 - float((int(y_center2) & 1) ^ field_glitch) * v_dyn_pack1.w;

			vec3 final_lines = profile1 + profile2;
			if (scanline_cutoff > 0.0) {
				float luma = dot(raw1, vec3(0.333));
				result_color = mix(raw1, final_lines, smoothstep(0.0, scanline_cutoff, luma));
			} else {
				result_color = final_lines;
			}
		}
	} else {
		int iy = int(floor(scaled_uv.y));
		vec3 color = fast ? srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb) : sample_row(ix, iy, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
		
		int abstract_iy = int(floor(abstract_y));
		color *= 1.0 - float((abstract_iy & 1) ^ int(v_glitch_field.z)) * v_dyn_pack1.w; 
		result_color = color;
	}

	if (use_interleaved_fields && field_line_blanking > 0.0) {
		int line_parity = int(floor(abstract_y)) & 1;
		result_color *= 1.0 - float(line_parity ^ int(v_glitch_field.z)) * field_line_blanking;
	}

	return result_color;
}

vec3 mask(vec3 linear_color, vec2 coords) {
	vec3 m_rgb = vec3(0.5);
	float m_w = 0.5;

	float cx = coords.x * TWO_THIRD_PI;

	switch (mask_type) {
		case 1: 
			m_rgb = 0.5 + 0.5 * cos(cx - PHASE_OFFSETS);
			m_w = 0.25;
			m_rgb *= (0.5 + 0.5 * cos(coords.y * PI));
			break;
		case 2: 
			m_rgb = mix(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 1.0), 0.5 + 0.5 * cos(coords.x * PI));
			break;
		case 3: 
			m_rgb = clamp(0.5 + 0.8 * cos(cx - PHASE_OFFSETS), 0.0, 1.0);
			m_w = 0.25;
			break;
		case 4: 
			m_rgb = 0.5 + 0.5 * cos(cx - PHASE_OFFSETS);
			m_w = 0.3125;
			break;
		case 5: 
			m_rgb = 0.5 + 0.5 * cos(cx - PHASE_OFFSETS);
			m_w = 0.375;
			m_rgb *= (0.5 + 0.5 * cos((coords.y + (0.5 - 0.5 * cos(cx)) * 0.5) * TAU));
			break;
		case 6: 
			m_rgb = vec3(1.0);
			m_w = mix(1.0, 0.6, clamp(0.5 + 1.5 * cos(cx), 0.0, 1.0)); 
			break;
		case 7: { 
			m_rgb = clamp(0.5 + 1.5 * cos(cx - PHASE_OFFSETS), 0.0, 1.0);
			m_w = 0.6;
			break;
		}
		case 8: { 
			m_rgb = clamp(0.5 + 1.5 * cos(cx - PHASE_OFFSETS), 0.0, 1.0);
			m_rgb *= clamp(0.5 + 1.5 * cos(coords.y * TAU), 0.0, 1.0);
			m_w = 0.6;
			break;
		}
		case 9: { 
			float shift = (0.5 - 0.5 * cos(coords.y * PI)) * TWO_THIRD_PI;
			m_rgb = clamp(0.5 + 1.5 * cos(cx + shift - PHASE_OFFSETS), 0.0, 1.0);
			m_w = 0.6;
			break;
		}
	}

	linear_color *= mix(m_w, 1.0, v_dyn_pack1.z);
	vec3 target_color = linear_color * (1.0 / m_w);
	vec3 primary_col = clamp(target_color, 0.0, 1.0);
	vec3 highlights = target_color - primary_col;
	
	if (m_w < 0.999) {
		highlights *= m_w / (1.0 - m_w);
	} else {
		highlights = vec3(0.0); 
	}
	
	return primary_col * m_rgb + highlights * (1.0 - m_rgb);
}

void fragment() {
	float fw_x = max(fwidth(UV.x), 0.0001);
	float fw_y = max(fwidth(UV.y), 0.0001);
	float quad_aspect = fw_y / fw_x;
	vec2 quad_pixels = vec2(1.0 / fw_x, 1.0 / fw_y);

	vec2 warped_coords = warp(UV);
	vec2 aspect_coords = vec2(warped_coords.x * quad_aspect, warped_coords.y);
	
	if (power_state < 0.001 || warped_coords.x < 0.0 || warped_coords.x > 1.0 || warped_coords.y < 0.0 || warped_coords.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		warped_coords.x += v_degauss_data.y;

		float in_v_blank = 0.0;
		if (use_v_blanking) {
			float roll_t = TIME * v_blanking_speed;
			float v_bar_y = fract(warped_coords.y - roll_t);
			if (v_bar_y < v_blanking_bar_size) {
				in_v_blank = 1.0;
			} else {
				float tear_dist = v_bar_y - v_blanking_bar_size;
				warped_coords.x += exp(-20.0 * tear_dist) * sin(tear_dist * 50.0) * v_blanking_tearing;
			}
		}

		float crease_factor = 0.0;
		if (use_tape_crease) {
			float travel_distance = 1.0 + (crease_width * 2.0);
			float active_time = travel_distance / max(0.001, crease_speed);
			float total_time = active_time + crease_interval;
			float local_t = mod(TIME, total_time);
			if (local_t < active_time) {
				float c_pos = -crease_width + (local_t * crease_speed);
				float dist = abs(warped_coords.y - c_pos);
				crease_factor = smoothstep(crease_width, crease_width * 0.2, dist);
				if (crease_factor > 0.0) {
					float crease_noise = value_noise_1(vec2(aspect_coords.y * 100.0, TIME * 20.0));
					warped_coords.x += (crease_noise - 0.5) * crease_factor * crease_noise_strength * 0.1;
				}
			}
		}

		if (use_edge_wobble) {
			float wobble_noise = value_noise_1(vec2(aspect_coords.y * edge_wobble_scale, TIME * edge_wobble_speed));
			warped_coords.x += (wobble_noise - 0.5) * edge_wobble_strength;
		}

		float head_switch_t = 0.0;
		if (use_head_switching) {
			float switch_start = 1.0 - head_switch_height;
			if (warped_coords.y > switch_start) {
				head_switch_t = (warped_coords.y - switch_start) / max(0.0001, head_switch_height);
				float curve_power = pow(head_switch_t, head_switch_curve);
				float jitter = value_noise_1(vec2(aspect_coords.y * 100.0, TIME * 15.0));
				warped_coords.x += curve_power * head_switch_strength * (0.8 + 0.4 * jitter);
			}
		}

		if (use_interlaced_jitter && interlaced_jitter_strength > 0.0) {
			float row_id = floor(warped_coords.y * v_extra_data.y);
			float jitter_mod = sin(v_optim_pack.w + row_id * interlaced_jitter_frequency);
			if (interlaced_jitter_random) {
				jitter_mod *= fract(sin(row_id * 12.9898 + TIME) * 43758.5453);
			}
			warped_coords.x += ((int(row_id) & 1) == 0 ? jitter_mod : -jitter_mod) * interlaced_jitter_strength;
		}
		
		if (use_h_sync_loss && h_sync_strength > 0.0) {
			float h_sync_noise = value_noise_1(vec2(v_extra_data.w, 0.0));
			float h_sync_mask = smoothstep(h_sync_threshold, h_sync_threshold + 0.1, h_sync_noise);
			if (h_sync_mask > 0.0) {
				float skew = fract(warped_coords.y * h_sync_frequency + TIME * 5.0) - 0.5;
				warped_coords.x += skew * h_sync_strength * h_sync_mask;
			}
		}

		float track_snow = 0.0;
		if (v_optim_pack.y > -999.0) {
			float track_band = step(v_optim_pack.y, warped_coords.y) * step(warped_coords.y, v_optim_pack.y + vhs_tracking_height);
			if (track_band > 0.0) {
				float track_row = floor(aspect_coords.y * vhs_tracking_noise_scale);
				float pseudo_rand = fract(sin(track_row + TIME * 10.0) * 43758.5453);
				warped_coords.x += (pseudo_rand - 0.5) * vhs_tracking_strength * 0.2;
				if (vhs_tracking_snow && vhs_tracking_snow_strength > 0.0) {
					float snow_x = floor(warped_coords.x * mix(180.0, 12.0, vhs_tracking_snow_anisotropy));
					float snow_line = floor(warped_coords.y * v_extra_data.y);
					float snow_rnd = hash12(vec2(snow_x + floor(TIME * 60.0) * 19.31, snow_line));
					float snow_env = sin(((warped_coords.y - v_optim_pack.y) / max(vhs_tracking_height, 0.0001)) * PI);
					track_snow = (smoothstep(0.76, 0.99, snow_rnd) - smoothstep(0.24, 0.01, snow_rnd) * 0.65) * snow_env * vhs_tracking_snow_strength;
				}
			}
		}
		
		if (v_degauss_data.x > 0.0) {
			vec2 center_offset = warped_coords - 0.5;
			float dist = length(center_offset);
			float bulge = sin(dist * 20.0 - v_time_pack1.x) * v_degauss_data.z;
			float ripple = sin(dist * 50.0 - v_time_pack1.y) * v_degauss_data.w;
			warped_coords += center_offset * (bulge + ripple);
			warped_coords.x += exp(-50.0 * (warped_coords.y - v_time_pack1.z) * (warped_coords.y - v_time_pack1.z)) * sin(warped_coords.y * 100.0) * v_extra_data.x;
		}

		if (v_dyn_pack2.y > 0.0) warped_coords.x += step(abs(warped_coords.y - v_glitch_field.x), glitch_size) * v_glitch_field.y;
		if (vsync_tearing > 0.0) {
			float tear_dist = warped_coords.y - v_time_pack1.w;
			warped_coords.x += exp(-100.0 * tear_dist * tear_dist) * sin(warped_coords.y * 150.0) * vsync_tearing;
		}

		float stripe_factor = 0.0;
		vec2 local_chroma = vec2(0.0);
		vec2 rotated_uv = vec2(0.0); 
		
		if (use_sweep_stripe) {
			vec2 centered_uv = warped_coords - 0.5;
			mat2 stripe_rot = mat2(vec2(v_stripe_calc.y, v_stripe_calc.z), vec2(-v_stripe_calc.z, v_stripe_calc.y));
			rotated_uv = (stripe_rot * centered_uv) + 0.5;
			float norm_dist = abs(rotated_uv.y - v_stripe_calc.x) * v_stripe_calc.w;

			if (norm_dist <= 1.0) {
				if (stripe_profile == 1) stripe_factor = exp(-4.0 * norm_dist * norm_dist);
				else if (stripe_profile == 2) stripe_factor = (1.0 - norm_dist) * (1.0 - norm_dist); 
				else { 
					float norm_smooth = max((rotated_uv.y < v_stripe_calc.x) ? stripe_smoothness_lead : stripe_smoothness_trail, 0.001);
					float t = clamp((1.0 - norm_dist) / norm_smooth, 0.0, 1.0);
					if (stripe_profile == 0) stripe_factor = t * t * (3.0 - 2.0 * t);
					else stripe_factor = (0.5 + 0.5 * cos(norm_dist * PI)) * t;
				}
			}
		}

		vec3 col = sample_image(warped_coords, local_chroma);
		
		if (in_v_blank > 0.0) {
			col = vec3(0.0);
		}
		if (track_snow != 0.0) {
			col = clamp(col + vec3(track_snow), 0.0, 1.0);
		}
		
		if (use_analog_clipping) {
			col = clamp((col + analog_pedestal) * analog_gain, 0.0, 1.0);
		}

		float inv_bw = v_phase_err_anim.w;
		float bw_freq = use_bandwidth_scale ? bandwidth_scale : 1.0;

		bool need_yiq = use_yiq_bleed || use_vertical_chroma_smear || use_tape_noise || use_color_killer || use_yc_delay || use_tape_crease || use_vhs_tape_speed || use_vhs_sharpen || use_luma_smear || use_chroma_dropout || use_chroma_demod || use_chroma_phase_error || (use_scanline_phase_noise && scanline_phase_noise_strength > 0.0) || (use_head_switching && head_switch_color_recovery && head_switch_t > 0.0);
		if (need_yiq) {
			vec3 center_yiq = rgb_to_yiq(col);
			float final_y = center_yiq.x;
			float final_i = center_yiq.y;
			float final_q = center_yiq.z;

			if (use_vhs_tape_speed && v_vhs_speed_pack.w > 0.0) {
				vec3 l_rgb = (srgb_to_linear(textureLod(tex, warped_coords - vec2(v_vhs_speed_pack.x, 0.0), 0.0).rgb) +
				              srgb_to_linear(textureLod(tex, warped_coords + vec2(v_vhs_speed_pack.x, 0.0), 0.0).rgb)) * 0.5;
				float blurred_y = mix(final_y, dot(l_rgb, HUE_LUMA), 0.5 * v_vhs_speed_pack.w);

				vec2 c_base = warped_coords + vec2(v_vhs_speed_pack.z, 0.0);
				vec3 c_rgb = srgb_to_linear(textureLod(tex, c_base - vec2(v_vhs_speed_pack.y * 2.0, 0.0), 0.0).rgb) * 0.15 +
				             srgb_to_linear(textureLod(tex, c_base - vec2(v_vhs_speed_pack.y, 0.0), 0.0).rgb) * 0.22 +
				             srgb_to_linear(textureLod(tex, c_base, 0.0).rgb) * 0.26 +
				             srgb_to_linear(textureLod(tex, c_base + vec2(v_vhs_speed_pack.y, 0.0), 0.0).rgb) * 0.22 +
				             srgb_to_linear(textureLod(tex, c_base + vec2(v_vhs_speed_pack.y * 2.0, 0.0), 0.0).rgb) * 0.15;
				vec3 c_yiq = rgb_to_yiq(c_rgb);

				final_y = blurred_y;
				final_i = mix(final_i, c_yiq.y, v_vhs_speed_pack.w);
				final_q = mix(final_q, c_yiq.z, v_vhs_speed_pack.w);
			}

			if (use_luma_smear && luma_smear_strength > 0.0) {
				float sm_step = v_tex_data.z * luma_smear_length * inv_bw;
				float y1 = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(sm_step * 0.33, 0.0), 0.0).rgb), HUE_LUMA);
				float y2 = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(sm_step * 0.66, 0.0), 0.0).rgb), HUE_LUMA);
				float y3 = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(sm_step, 0.0), 0.0).rgb), HUE_LUMA);
				float smeared_y = (luma_smear_filter == 0)
					? (final_y * 0.45 + y1 * 0.30 + y2 * 0.17 + y3 * 0.08)
					: clamp(final_y * 0.55 + y1 * 0.40 + y2 * 0.17 - y3 * 0.12, 0.0, 1.0);
				final_y = mix(final_y, smeared_y, luma_smear_strength);
			}

			if (use_vhs_sharpen && vhs_sharpen_strength > 0.0) {
				float sh_offset = v_tex_data.z * vhs_sharpen_radius * inv_bw;
				float y_l = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(sh_offset, 0.0), 0.0).rgb), HUE_LUMA);
				float y_r = dot(srgb_to_linear(textureLod(tex, warped_coords + vec2(sh_offset, 0.0), 0.0).rgb), HUE_LUMA);
				float detail = final_y * 2.0 - y_l - y_r;
				final_y = clamp(final_y + detail * vhs_sharpen_strength * 0.5, 0.0, 1.0);
			}

			if (use_chroma_demod && chroma_demod_strength > 0.0) {
				float tap_dx = v_tex_data.z * inv_bw;
				vec3 demod_l = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords - vec2(tap_dx, 0.0), 0.0).rgb));
				vec3 demod_r = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords + vec2(tap_dx, 0.0), 0.0).rgb));
				vec2 box_iq = (demod_l.yz + vec2(final_i, final_q) * 2.0 + demod_r.yz) * 0.25;

				if (chroma_demod_filter == 0) {
					final_i = mix(final_i, box_iq.x, chroma_demod_strength);
					final_q = mix(final_q, box_iq.y, chroma_demod_strength);
				} else if (chroma_demod_filter == 1) {
					float hf_luma = (final_y * 2.0 - demod_l.x - demod_r.x) * 0.35;
					float sub_phase = warped_coords.x * v_tex_data.x * PI * bw_freq + warped_coords.y * v_extra_data.y * PI;
					final_i = mix(final_i, box_iq.x + hf_luma * cos(sub_phase), chroma_demod_strength);
					final_q = mix(final_q, box_iq.y + hf_luma * sin(sub_phase), chroma_demod_strength);
				} else {
					vec3 demod_u = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords - vec2(0.0, v_tex_data.w), 0.0).rgb));
					vec3 demod_d = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords + vec2(0.0, v_tex_data.w), 0.0).rgb));
					float v_edge = abs(demod_u.x - demod_d.x);
					float h_edge = abs(demod_l.x - demod_r.x);
					float comb_weight = clamp(h_edge / max(h_edge + v_edge, 0.0001), 0.0, 1.0);
					vec2 v_comb_iq = (demod_u.yz + vec2(final_i, final_q) * 2.0 + demod_d.yz) * 0.25;
					vec2 adaptive_iq = mix(box_iq, v_comb_iq, comb_weight);
					final_i = mix(final_i, adaptive_iq.x, chroma_demod_strength);
					final_q = mix(final_q, adaptive_iq.y, chroma_demod_strength);
				}
			}

			if (use_yc_delay) {
				vec3 delayed_col = sample_image(warped_coords - vec2(yc_delay_amount * v_tex_data.z, 0.0), local_chroma);
				vec3 delayed_yiq = rgb_to_yiq(delayed_col);
				final_i = delayed_yiq.y;
				final_q = delayed_yiq.z;
			}
			
			if (use_yiq_bleed) {
				vec3 raw_col = srgb_to_linear(textureLod(tex, warped_coords, 0.0).rgb);
				float raw_luma = rgb_to_yiq(raw_col).x;
				float luma_mask = (raw_luma > 0.001) ? (final_y / raw_luma) : 0.0;
				
				float spread = yiq_bleed_spread * v_tex_data.z * inv_bw;
				float offset = yiq_chroma_offset * v_tex_data.z;
				
				vec3 rgb0 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset - spread * 2.0, 0.0), 0.0).rgb);
				vec3 rgb1 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset - spread, 0.0), 0.0).rgb);
				vec3 rgb2 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset, 0.0), 0.0).rgb);
				vec3 rgb3 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset + spread, 0.0), 0.0).rgb);
				vec3 rgb4 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset + spread * 2.0, 0.0), 0.0).rgb);

				vec3 blurred_rgb = (yiq_bleed_filter == 0)
					? ((rgb0 + rgb4) * 0.0625 + (rgb1 + rgb3) * 0.25 + rgb2 * 0.375)
					: (-(rgb0 + rgb4) * 0.085 + (rgb1 + rgb3) * 0.345 + rgb2 * 0.48);
				vec3 blurred_yiq = rgb_to_yiq(blurred_rgb);

				final_i = blurred_yiq.y * luma_mask;
				final_q = blurred_yiq.z * luma_mask;
			}
			
			if (use_vertical_chroma_smear && chroma_smear_strength > 0.0) {
				float v_offset = v_tex_data.w * chroma_smear_scanlines;
				vec3 up_yiq = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords - vec2(0.0, v_offset), 0.0).rgb));
				vec3 down_yiq = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords + vec2(0.0, v_offset), 0.0).rgb));
				
				final_i = mix(final_i, (up_yiq.y + down_yiq.y + final_i) * 0.3333333, chroma_smear_strength);
				final_q = mix(final_q, (up_yiq.z + down_yiq.z + final_q) * 0.3333333, chroma_smear_strength);
			}

			if (use_chroma_phase_error && v_phase_err_anim.z > 0.0) {
				vec2 iq = vec2(final_i, final_q);
				float chroma_mag = length(iq);
				if (chroma_mag > 0.001) {
					float angle_match = max(0.0, dot(iq / chroma_mag, v_phase_err_pack.xy));
					float phase_weight = pow(angle_match, v_phase_err_anim.y) * v_phase_err_anim.z;
					if (phase_weight > 0.001) {
						if (v_phase_err_anim.x > 0.0) {
							vec3 bleed_yiq = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords - vec2(v_phase_err_anim.x * v_tex_data.z * inv_bw * phase_weight, 0.0), 0.0).rgb));
							iq = mix(iq, bleed_yiq.yz, phase_weight * 0.65);
						}
						mat2 phase_rot = mat2(vec2(v_phase_err_pack.z, v_phase_err_pack.w), vec2(-v_phase_err_pack.w, v_phase_err_pack.z));
						iq = mix(iq, phase_rot * iq, phase_weight);
						final_i = iq.x;
						final_q = iq.y;
					}
				}
			}

			if (use_scanline_phase_noise && scanline_phase_noise_strength > 0.0) {
				float line_idx = floor(warped_coords.y * v_extra_data.y);
				float line_rand = hash12(vec2(line_idx, floor(TIME * scanline_phase_noise_speed) * 1.37)) - 0.5;
				float jitter_ang = line_rand * scanline_phase_noise_strength;
				float jc = cos(jitter_ang);
				float js = sin(jitter_ang);
				float rot_i = final_i * jc - final_q * js;
				float rot_q = final_i * js + final_q * jc;
				final_i = rot_i;
				final_q = rot_q;
			}

			if (use_head_switching && head_switch_color_recovery && head_switch_t > 0.0) {
				float pll_env = pow(head_switch_t, head_switch_curve);
				float pll_osc = cos(head_switch_t * 18.84955) * pll_env;
				float pll_ang = pll_osc * head_switch_hue_twist;
				float pc = cos(pll_ang);
				float ps = sin(pll_ang);
				float sat_boost = 1.0 + abs(pll_osc) * head_switch_sat_spike;
				float rot_i = (final_i * pc - final_q * ps) * sat_boost;
				float rot_q = (final_i * ps + final_q * pc) * sat_boost;
				final_i = rot_i;
				final_q = rot_q;
			}

			if (use_tape_noise && tape_noise_strength > 0.0) {
				vec3 t_noise = fbm_3(aspect_coords * tape_noise_scale + vec2(TIME * tape_noise_speed, -TIME * tape_noise_speed * 0.5), 2, 2.0, 0.5);
				if (use_tape_noise_streak && tape_noise_streak_detail > 0.0) {
					float line_y = floor(warped_coords.y * v_extra_data.y);
					float x_stretch = mix(1.0, 0.04, tape_noise_streak_anisotropy);
					vec2 streak_uv = vec2(aspect_coords.x * tape_noise_scale * 16.0 * x_stretch + floor(TIME * tape_noise_speed * 15.0) * 13.7, line_y);
					t_noise = mix(t_noise, value_noise_3(streak_uv), tape_noise_streak_detail);
				}
				final_i += (t_noise.x - 0.5) * tape_noise_strength;
				final_q += (t_noise.y - 0.5) * tape_noise_strength;
			}

			if (use_color_killer) {
				float killer_noise = fbm_1(vec2(aspect_coords.y * 5.0, TIME * 10.0), 2, 2.0, 0.5);
				float killer_mult = smoothstep(color_killer_threshold - 0.05, color_killer_threshold + 0.05, killer_noise);
				final_i *= killer_mult;
				final_q *= killer_mult;
			}

			if (use_chroma_dropout && chroma_dropout_rate > 0.0 && chroma_dropout_strength > 0.0) {
				float scrolled_y = warped_coords.y + TIME * chroma_dropout_drift_speed;
				float line_idx = floor(scrolled_y * v_extra_data.y);
				float drop_noise = value_noise_1(vec2(
					line_idx * chroma_dropout_line_scale + warped_coords.x * chroma_dropout_patch_length,
					floor(TIME * chroma_dropout_speed) * 7.13
				));
				float edge_low = 1.0 - chroma_dropout_rate;
				float drop_mask = smoothstep(edge_low - chroma_dropout_softness, edge_low + chroma_dropout_softness, drop_noise) * chroma_dropout_strength;
				if (drop_mask > 0.0) {
					final_i *= (1.0 - drop_mask);
					final_q *= (1.0 - drop_mask);
					if (chroma_dropout_static > 0.0) {
						vec2 static_coord = vec2(warped_coords.x * chroma_dropout_static_scale + TIME * 50.0, line_idx);
						float pop = (hash12(static_coord) - 0.5) * chroma_dropout_static * drop_mask;
						if (chroma_dropout_static_mode == 1) {
							final_y = clamp(final_y + pop, 0.0, 1.0);
						} else if (chroma_dropout_static_mode == 2) {
							float pop2 = (hash12(static_coord + vec2(37.2, 11.9)) - 0.5) * chroma_dropout_static * drop_mask;
							final_i += pop * 1.25;
							final_q += pop2 * 1.25;
						} else {
							final_i += pop;
							final_q -= pop * 0.7;
						}
					}
				}
			}

			if (use_tape_crease && crease_factor > 0.0) {
				vec3 c_noise = fbm_3(aspect_coords * 10.0 + vec2(TIME * 10.0, 0.0), 3, 2.0, 0.5);
				final_i += (c_noise.x - 0.5) * crease_factor * crease_noise_strength;
				final_q += (c_noise.y - 0.5) * crease_factor * crease_noise_strength;
				
				float crease_killer = fbm_1(vec2(aspect_coords.y * 10.0, TIME * 15.0), 2, 2.0, 0.5);
				float kill_mult = smoothstep(0.4, 0.6, crease_killer + (1.0 - crease_factor));
				final_i *= kill_mult;
				final_q *= kill_mult;
			}

			col = yiq_to_rgb(vec3(final_y, final_i, final_q));
		}

		bool need_l1_r1 = use_signal_ringing || use_dot_crawl || use_cross_color || use_cross_luminance || use_pre_emphasis || (use_composite_sharpening && abs(composite_sharpening) > 0.001);
		if (need_l1_r1) {
			float tap_dx = v_tex_data.z * inv_bw;
			vec3 l1 = sample_image(warped_coords - vec2(tap_dx, 0.0), local_chroma);
			vec3 r1 = sample_image(warped_coords + vec2(tap_dx, 0.0), local_chroma);

			if (use_composite_sharpening && abs(composite_sharpening) > 0.001) {
				vec3 comp_detail = col - (l1 + r1) * 0.5;
				col = clamp(col + comp_detail * composite_sharpening, 0.0, 1.0);
			}

			if (use_pre_emphasis && pre_emphasis_strength > 0.0) {
				float l_center = dot(col, HUE_LUMA);
				float l_left = dot(l1, HUE_LUMA);
				float l_right = dot(r1, HUE_LUMA);
				float hf_luma = l_center * 2.0 - l_left - l_right;
				float edge_gate = smoothstep(pre_emphasis_cutoff, pre_emphasis_cutoff + 0.15, abs(hf_luma));
				col = clamp(col + vec3(hf_luma * pre_emphasis_strength * edge_gate), 0.0, 1.0);
			}
			
			if (use_signal_ringing && ringing_strength > 0.0) {
				vec3 l2 = sample_image(warped_coords - vec2(tap_dx * 2.0, 0.0), local_chroma);
				vec3 r2 = sample_image(warped_coords + vec2(tap_dx * 2.0, 0.0), local_chroma);
				
				vec3 ringing_kernel = (col * 2.0 - l1 - r1) - 0.5 * (l2 + r2 - 2.0 * col);
				col += ringing_kernel * ringing_strength;
			}
			
			if (use_cross_color && cross_color_strength > 0.0) {
				float l_center = dot(col, HUE_LUMA);
				float l_l = dot(l1, HUE_LUMA);
				float l_r = dot(r1, HUE_LUMA);
				
				float hf_signal = abs(l_center * 2.0 - l_l - l_r);
				float moire_mask = smoothstep(cross_color_threshold, cross_color_threshold + 0.2, hf_signal);
				
				if (moire_mask > 0.0) {
					float moire_phase = warped_coords.x * (v_extra_data.y * aspect) * 3.14159 * bw_freq + warped_coords.y * v_extra_data.y * 1.57079 - TIME * 15.0;
					vec3 yiq = rgb_to_yiq(col);
					yiq.y += sin(moire_phase) * moire_mask * cross_color_strength * 0.5;
					yiq.z += cos(moire_phase) * moire_mask * cross_color_strength * 0.5;
					col = yiq_to_rgb(yiq);
				}
			}

			if (use_cross_luminance && cross_luminance_strength > 0.0) {
				vec3 yiq_l = rgb_to_yiq(l1);
				vec3 yiq_r = rgb_to_yiq(r1);
				
				float chroma_diff = distance(yiq_l.yz, yiq_r.yz);
				float luma_diff = abs(yiq_l.x - yiq_r.x);
				
				float zipper_mask = smoothstep(0.05, 0.2, chroma_diff) * (1.0 - smoothstep(0.0, 0.1, luma_diff));
				if (zipper_mask > 0.0) {
					float zipper_phase = warped_coords.y * v_extra_data.y * 3.14159 * bw_freq - TIME * 15.0;
					vec3 center_yiq = rgb_to_yiq(col);
					center_yiq.x += sin(zipper_phase) * zipper_mask * cross_luminance_strength * 0.5;
					col = yiq_to_rgb(center_yiq);
				}
			}
			
			if (use_dot_crawl && dot_crawl_strength > 0.0) {
				float luma_left = dot(l1, HUE_LUMA);
				float luma_right = dot(r1, HUE_LUMA);
				float edge_intensity = abs(luma_right - luma_left);
				
				float edge_mask = smoothstep(dot_crawl_threshold, dot_crawl_threshold + 0.1, edge_intensity);
				vec2 dot_crawl_coords = warped_coords * quad_pixels;
				float pattern = sin(dot_crawl_coords.x * PI * bw_freq) * sin(dot_crawl_coords.y * PI + v_time_pack2.x);
				col += pattern * edge_mask * dot_crawl_strength;
			}
		}

		if (use_dpg) {
			float luma = dot(col, HUE_LUMA);
			if (abs(phase_shift) > 0.001) col = shift_hue(col, luma * phase_shift);
			if (abs(gain_multiplier) > 0.001) {
				float sat_mult = 1.0 + (luma - 0.5) * gain_multiplier;
				col = mix(vec3(luma), col, max(0.0, sat_mult));
			}
		}
		
		if (use_phase_drift && phase_drift_strength > 0.0) {
			float line_idx = floor(warped_coords.y * v_extra_data.y);
			float drift = sin(v_extra_data.z) * phase_drift_strength;
			float phase_mod = ((int(line_idx) & 1) == 0) ? drift : -drift;
			col = shift_hue(col, phase_mod);
		}

		if (use_sweep_stripe && stripe_factor > 0.0) {
			if (stripe_enable_hue) {
				float current_hue = stripe_hue_shift;
				if (stripe_hue_oscillate) {
					float spatial_coord = ((stripe_hue_osc_axis == 1) ? rotated_uv.x : rotated_uv.y) * stripe_hue_osc_scale;
					float osc_val = evaluate_wave(stripe_hue_osc_profile, (spatial_coord + stripe_hue_osc_offset) * stripe_hue_osc_freq + v_dyn_pack3.z);
					current_hue += mix(stripe_hue_osc_min, stripe_hue_osc_max, osc_val) * stripe_hue_osc_intensity;
				}
				col = shift_hue(col, current_hue * stripe_factor);
			}
			if (stripe_enable_secondary_hue) {
				float current_secondary_hue = stripe_secondary_hue_shift;
				float current_mix_factor = stripe_secondary_mix * stripe_factor;
				if (stripe_secondary_wave_enabled) {
					float spatial_coord = ((stripe_secondary_wave_axis == 0) ? rotated_uv.x : rotated_uv.y) * stripe_secondary_wave_scale;
					float wave_val = evaluate_wave(stripe_secondary_wave_profile, (spatial_coord + stripe_secondary_wave_offset) * stripe_secondary_wave_freq + v_dyn_pack3.w);
					current_secondary_hue += mix(stripe_secondary_wave_min, stripe_secondary_wave_max, wave_val) * stripe_secondary_wave_intensity;
				}
				col = mix(col, shift_hue(col, current_secondary_hue * stripe_factor), current_mix_factor);
			}
			if (stripe_enable_brightness) col *= 1.0 + stripe_factor * (stripe_brightness - 1.0); 
			if (stripe_enable_contrast) col = clamp((col - 0.5) * mix(1.0, stripe_contrast, stripe_factor) + 0.5, 0.0, 1.0);
			if (stripe_enable_saturation) col = mix(vec3(dot(col, HUE_LUMA)), col, 1.0 + stripe_factor * (stripe_saturation - 1.0)); 
		}

		if (v_degauss_data.x > 0.0) {
			if (degauss_hue_shift_amount > 0.0) col = shift_hue(col, v_degauss_data.x * degauss_hue_shift_amount);
			if (degauss_invert_strength > 0.0) col = mix(col, vec3(1.0) - col, v_degauss_data.x * degauss_invert_strength);
		}
		
		if (v_dyn_pack3.x > 0.0) col += srgb_to_linear(textureLod(tex, warped_coords - vec2(v_dyn_pack3.y, 0.0), 0.0).rgb) * v_dyn_pack3.x;
		if (v_dyn_pack2.x > 0.0) col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_coords.y * roll_size - v_time_pack2.y)) * v_dyn_pack2.x;

		if (v_dyn_pack2.z > 0.0) {
			vec2 frame_offset = vec2(
				fract(sin(floor(v_time_pack1.x) * 12.9898) * 43758.5453),
				fract(sin(floor(v_time_pack1.x) * 78.233) * 43758.5453)
			) * 1000.0;
			
			vec2 noise_coords = (warped_coords * quad_pixels) * (noise_base_scale * 0.05) + frame_offset;

			vec3 noise_val;
			if (chroma_noise) {
				noise_val = fbm_3(noise_coords, noise_octaves, noise_lacunarity, noise_gain);
			} else {
				noise_val = vec3(fbm_1(noise_coords, noise_octaves, noise_lacunarity, noise_gain));
			}
			col += (noise_val - 0.5) * v_dyn_pack2.z;
		}
		
		if (use_tape_dropouts && dropout_rate > 0.0) {
			vec2 drop_uv = vec2(aspect_coords.x * 4.0, aspect_coords.y * dropout_scale);
			drop_uv.y -= TIME * dropout_speed;
			drop_uv.x += TIME * (dropout_speed * 0.1);
			
			float drop_noise = fbm_1(drop_uv, 3, 2.0, 0.5);
			float drop_mask = smoothstep(1.0 - dropout_rate, 1.0, drop_noise);
			
			if (drop_mask > 0.0) {
				float drop_static = value_noise_1((warped_coords * quad_pixels * 0.1) + vec2(fract(TIME * 13.37) * 100.0, fract(TIME * 7.77) * 100.0));
				col = mix(col, vec3(drop_static * 1.5), drop_mask * dropout_strength);
			}
		}

		vec2 mask_coords = warped_coords * quad_pixels;
		mask_coords *= v_time_pack2.w; 
		col = mask(col, mask_coords);

		if (use_auto_exposure) {
			float luma = dot(col, HUE_LUMA);
			col = mix(col, vec3(1.0), smoothstep(exposure_threshold, 1.0, luma) * exposure_intensity);
		}
		if (use_color_quantization) col = floor(col * color_levels) / color_levels;
		if (use_gradient_map) {
			float luma = dot(col, HUE_LUMA);
			col = textureLod(gradient_texture, vec2(clamp(luma, 0.0, 1.0), 0.0), 0.0).rgb;
		}
		if (use_monochrome) {
			float luma = dot(col, HUE_LUMA);
			col = monochrome_color.rgb * luma;
		}
		if (use_motion_persistence) {
			vec3 prev_col = srgb_to_linear(textureLod(previous_frame_tex, warped_coords, 0.0).rgb);
			col = mix(col, prev_col, persistence_strength);
		}

		if (use_hum_bar && hum_bar_strength > 0.0) {
			float hum = 0.5 + 0.5 * sin(warped_coords.y * 10.0 - TIME * hum_bar_speed);
			col *= 1.0 - (hum * hum_bar_strength);
		}
		if (use_glare && glare_strength > 0.0) {
			vec2 centered = warped_coords - glare_position;
			mat2 rot_mat = mat2(vec2(v_glare_calc.x, v_glare_calc.y), vec2(-v_glare_calc.y, v_glare_calc.x));
			vec2 rot_uv = rot_mat * centered;
			float glare = smoothstep(v_glare_calc.w, glare_size, abs(rot_uv.x));
			col += vec3(glare * glare_strength);
		}
		if (use_glass_reflection) {
			vec2 env_uv = warped_coords - 0.5;
			if (glass_curve > 0.0) {
				env_uv.x *= v_warp_power_pack.x;
				env_uv /= 1.0 - glass_curve * (dot(env_uv, env_uv) - 0.25);
				env_uv.x *= v_warp_power_pack.y;
			}
			env_uv = (env_uv * v_glass_env_pack.xy) + v_glass_env_pack.zw;
			
			vec3 env = srgb_to_linear(textureLod(glass_env_tex, env_uv, glass_blur).rgb);
			env *= v_glass_tint_pack.rgb;
			
			if (abs(glass_saturation - 1.0) > 0.001) {
				env = mix(vec3(dot(env, HUE_LUMA)), env, glass_saturation);
			}
			
			vec3 blended;
			if (glass_blend_mode == 0) blended = col + env;
			else if (glass_blend_mode == 1) blended = 1.0 - (1.0 - col) * (1.0 - env);
			else blended = max(col, env);
			
			col = mix(col, blended, v_glass_tint_pack.a);
		}
		if (bezel_shadow_strength > 0.0) {
			vec2 edge_dist = abs(warped_coords - 0.5) * 2.0;
			float shadow = smoothstep(v_glare_calc.z, 1.0, max(edge_dist.x, edge_dist.y));
			col *= 1.0 - (shadow * bezel_shadow_strength);
		}
		
		if (v_optim_pack.x > 0.0) {
			col = mix(col, power_flash_color.rgb, v_optim_pack.x);
		}

		COLOR.rgb = linear_to_srgb(col);
	}
}