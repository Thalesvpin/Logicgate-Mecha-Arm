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
uniform bool use_rgb_scanline_phase = false;
uniform float rgb_scanline_phase_offset : hint_range(-0.5, 0.5) = 0.15;

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
uniform bool use_hsync_tbc_jitter = false;
uniform float hsync_tbc_jitter_strength : hint_range(0.0, 0.02) = 0.002;
uniform float hsync_tbc_jitter_speed : hint_range(0.0, 60.0) = 30.0;

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

group_uniforms Subcarrier_Phase_Pattern;
uniform bool use_subcarrier_line_phase = false;
uniform int subcarrier_line_phase_step : hint_enum("0 deg:0", "90 deg:1", "180 deg:2", "270 deg:3") = 2;
uniform bool subcarrier_frame_alternate = true;
uniform float subcarrier_phase_offset : hint_range(0.0, 6.28318) = 0.0;

group_uniforms Luma_Smear;
uniform bool use_luma_smear = false;
uniform float luma_smear_strength : hint_range(0.0, 1.0) = 0.4;
uniform float luma_smear_length : hint_range(1.0, 30.0) = 6.0;
uniform int luma_smear_filter : hint_enum("Constant-K (Smooth):0", "Butterworth (Ripple):1") = 0;
uniform bool use_fm_slew_rate = false;
uniform float fm_slew_rate_limit : hint_range(0.01, 1.0) = 0.12;
uniform float fm_slew_rate_mix : hint_range(0.0, 1.0) = 1.0;

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
uniform bool use_chroma_demod_axis_error = false;
uniform float chroma_demod_axis_skew : hint_range(-1.57, 1.57) = 0.35;

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

group_uniforms Chroma_Gain_Ripple;
uniform bool use_chroma_gain_ripple = false;
uniform float chroma_gain_ripple_strength : hint_range(0.0, 1.0) = 0.35;
uniform float chroma_gain_ripple_freq : hint_range(1.0, 100.0) = 18.0;
uniform float chroma_gain_ripple_speed : hint_range(-20.0, 20.0) = 6.0;

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
uniform bool use_deemphasis_mismatch = false;
uniform float deemphasis_mismatch_gain : hint_range(-1.5, 1.5) = -0.35;
uniform float deemphasis_decay_pixels : hint_range(0.5, 12.0) = 3.0;

group_uniforms IRE_Pedestal_Clipping;
uniform bool use_analog_clipping = false;
uniform float analog_pedestal : hint_range(-0.5, 0.5) = 0.0;
uniform float analog_gain : hint_range(0.0, 5.0) = 1.0;

group_uniforms NTSC_Color_Bleed;
uniform bool use_yiq_bleed = false;
uniform int yiq_bleed_filter : hint_enum("Constant-K (Smooth):0", "Butterworth (Ripple):1") = 0;
uniform float yiq_bleed_spread : hint_range(0.1, 10.0) = 1.0;
uniform float yiq_chroma_offset : hint_range(-5.0, 5.0) = 0.0;
uniform bool use_asymmetric_yiq_bleed = false;
uniform float yiq_q_bleed_multiplier : hint_range(1.0, 5.0) = 2.5;
uniform bool use_vertical_chroma_smear = false;
uniform float chroma_smear_strength : hint_range(0.0, 1.0) = 1.0;
uniform float chroma_smear_scanlines : hint_range(0.1, 5.0) = 1.0;
uniform bool use_vertical_chroma_delay = false;
uniform float chroma_line_delay_mix : hint_range(0.0, 1.0) = 0.5;

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
uniform bool use_chroma_heterodyne_beat = false;
uniform float chroma_beat_strength : hint_range(0.0, 0.5) = 0.12;
uniform float chroma_beat_frequency : hint_range(1.0, 100.0) = 32.0;
uniform float chroma_beat_speed : hint_range(-30.0, 30.0) = 12.0;

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
uniform bool use_luma_notch_bleed = false;
uniform float luma_notch_bleed_strength : hint_range(0.0, 0.5) = 0.15;

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

group_uniforms Digital_Glitch_FX;
uniform bool use_macroblock_bitrot = false;
uniform float macroblock_rate : hint_range(0.0, 1.0) = 0.08;
uniform float macroblock_scale : hint_range(4.0, 64.0) = 16.0;
uniform float macroblock_speed : hint_range(0.0, 30.0) = 8.0;
uniform float macroblock_uv_shift : hint_range(0.0, 0.2) = 0.04;
uniform float macroblock_chroma_shift : hint_range(0.0, 1.0) = 0.5;

uniform bool use_datamosh_stretch = false;
uniform float datamosh_rate : hint_range(0.0, 1.0) = 0.06;
uniform float datamosh_band_scale : hint_range(2.0, 40.0) = 12.0;
uniform float datamosh_speed : hint_range(0.0, 20.0) = 4.0;
uniform float datamosh_stretch_amount : hint_range(0.0, 1.0) = 0.65;

group_uniforms Tape_Dropouts;
uniform bool use_tape_dropouts = false;
uniform float dropout_strength : hint_range(0.0, 1.0) = 1.0;
uniform float dropout_rate : hint_range(0.0, 0.2) = 0.02;
uniform float dropout_speed : hint_range(0.0, 50.0) = 20.0;
uniform float dropout_scale : hint_range(1.0, 1000.0) = 400.0;

group_uniforms RF_Static_Snow;
uniform bool use_rf_snow = false;
uniform float rf_snow_intensity : hint_range(0.0, 2.0) = 0.25;
uniform float rf_snow_scale : hint_range(0.1, 5.0) = 1.0;
uniform float rf_snow_anisotropy : hint_range(0.0, 1.0) = 0.5;
uniform float rf_snow_speed : hint_range(0.0, 60.0) = 30.0;

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

group_uniforms Optical_Lens_FX;
uniform bool use_halation = false;
uniform float halation_strength : hint_range(0.0, 2.0) = 0.45;
uniform float halation_threshold : hint_range(0.0, 1.0) = 0.55;
uniform float halation_radius : hint_range(1.0, 20.0) = 6.0;
uniform vec3 halation_color : source_color = vec3(1.0, 0.28, 0.08);

uniform bool use_anamorphic_streak = false;
uniform float anamorphic_streak_strength : hint_range(0.0, 2.0) = 0.5;
uniform float anamorphic_threshold : hint_range(0.0, 1.0) = 0.65;
uniform float anamorphic_streak_length : hint_range(5.0, 120.0) = 36.0;
uniform vec3 anamorphic_streak_color : source_color = vec3(0.25, 0.75, 1.0);

group_uniforms Display_Emulation_FX;
uniform bool use_vector_edge_glow = false;
uniform float vector_edge_strength : hint_range(0.0, 3.0) = 0.85;
uniform float vector_edge_threshold : hint_range(0.0, 1.0) = 0.08;
uniform vec3 vector_edge_color : source_color = vec3(0.35, 1.0, 0.65);

uniform bool use_vfd_display = false;
uniform float vfd_glow_strength : hint_range(0.0, 2.0) = 0.65;
uniform float vfd_mesh_strength : hint_range(0.0, 1.0) = 0.35;
uniform float vfd_mesh_scale : hint_range(10.0, 200.0) = 65.0;
uniform vec3 vfd_phosphor_color : source_color = vec3(0.15, 1.0, 0.72);

group_uniforms False_Color;
uniform int false_color_mode : hint_enum(
	"Off:0",
	"FLIR Ironbow Thermal:1",
	"White-Hot IR:2",
	"Black-Hot IR:3",
	"Predator Thermal:4",
	"Phosphor Night-Vision:5",
	"Rainbow / Jet Thermal:6",
	"Arctic / Cryo:7",
	"Inferno / Magma:8",
	"Viridis Scientific:9",
	"Amber Phosphor P3:10",
	"Cyan Radar / Sonar:11",
	"Exposure / Zebra Monitor:12"
) = 0;
uniform float false_color_mix : hint_range(0.0, 1.0) = 1.0;
uniform float false_color_gain : hint_range(0.1, 4.0) = 1.0;
uniform float false_color_offset : hint_range(-1.0, 1.0) = 0.0;
uniform float false_color_gamma : hint_range(0.2, 3.0) = 1.0;
uniform bool false_color_invert = false;
uniform float false_color_steps : hint_range(0.0, 32.0) = 0.0;
uniform float false_color_hue_shift : hint_range(-3.14159, 3.14159) = 0.0;

group_uniforms Stylization_FX;
uniform bool use_solarization = false;
uniform float solarization_threshold : hint_range(0.05, 0.95) = 0.5;
uniform float solarization_mix : hint_range(0.0, 1.0) = 1.0;

uniform bool use_bayer_dither = false;
uniform float bayer_dither_spread : hint_range(0.0, 0.5) = 0.12;
uniform float bayer_dither_scale : hint_range(0.25, 4.0) = 1.0;
uniform float bayer_dither_min_luma : hint_range(0.0, 1.0) = 0.15;
uniform float bayer_dither_fade_range : hint_range(0.01, 0.5) = 0.15;
uniform float bayer_dither_levels : hint_range(0.0, 32.0) = 8.0;

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

// Packed into 14 vec4s (56 floats) to stay strictly under the 64-component low-end/mobile GPU limit
varying flat vec4 v_tex_data;        // .xy = tex_size, .zw = pixel_size
varying flat vec4 v_degauss_data;    // .x = degauss_curve, .y = wobble_x, .z = bulge, .w = ripple
varying flat vec4 v_extra_data;      // .x = tear, .y = eff_scanlines, .z = dither_res, .w = inv_bw
varying flat vec4 v_vhs_speed_pack;  // .x = luma_blur_px, .y = chroma_blur_px, .z = chroma_shift_px, .w = mix
varying flat vec4 v_phase_err_pack;  // .xy = target_dir, .z = cos_shift, .w = sin_shift
varying flat vec4 v_phase_err_anim;  // .x = eff_bleed, .y = eff_selectivity, .z = shift_blend_mult, .w = power_flash_alpha
varying flat vec4 v_dyn_pack1;       // .x = color_split, .y = sharpness, .z = mask_brightness, .w = interlaced_strength
varying flat vec4 v_dyn_pack2;       // .x = roll_strength, .y = glitch_strength, .z = noise_strength, .w = inv_mask_scale
varying flat vec4 v_dyn_pack3;       // .x = echo_strength, .y = echo_offset, .z = vhs_tracking_y, .w = eff_scanline_brightness
varying flat vec4 v_glitch_field;    // .x = glitch_y, .y = glitch_shift, .z = field_parity, .w = jitter_time
varying flat vec4 v_stripe_calc;     // .x = stripe_pos, .y = cos_angle, .z = sin_angle, .w = inv_half_width
varying flat vec4 v_time_pack1;      // .x = TIME*60, .y = fract(TIME*0.2), .z = fract(TIME*0.1), .w = dot_crawl_time
varying flat vec4 v_time_pack2;      // .x = roll_time, .y = noise_offset.x, .z = noise_offset.y, .w = TIME*30
varying flat vec4 v_warp_power_pack; // .xy = aspect_inv/aspect, .zw = power_scale.xy

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

	float eff_scanlines = scanline_count * (base_tex_size.y / max(base_tex_size.x * aspect, 0.0001));
	float inv_bw = use_bandwidth_scale ? (1.0 / max(bandwidth_scale, 0.05)) : 1.0;

	if (use_vhs_tape_speed) {
		float l_spread = 0.4;
		float c_spread = 2.0;
		float c_shift = 0.5;
		if (vhs_tape_speed_mode == 1) {
			l_spread = 0.9;
			c_spread = 3.8;
			c_shift = 1.1;
		} else if (vhs_tape_speed_mode == 2) {
			l_spread = 1.5;
			c_spread = 6.0;
			c_shift = 1.8;
		} else if (vhs_tape_speed_mode == 3) {
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
		} else if (animate_chroma_phase_shift) {
			eff_shift += textureLod(chroma_phase_shift_curve, vec2(fract(TIME * chroma_phase_shift_anim_speed), 0.0), 0.0).r * chroma_phase_shift_anim_amplitude;
		}

		float eff_bleed = chroma_phase_bleed;
		if (animate_chroma_phase_bleed) {
			eff_bleed += textureLod(chroma_phase_bleed_curve, vec2(fract(TIME * chroma_phase_bleed_anim_speed), 0.0), 0.0).r * chroma_phase_bleed_anim_amplitude;
		}
		float eff_selectivity = chroma_phase_selectivity;
		if (animate_chroma_phase_selectivity) {
			eff_selectivity += textureLod(chroma_phase_selectivity_curve, vec2(fract(TIME * chroma_phase_selectivity_anim_speed), 0.0), 0.0).r * chroma_phase_selectivity_anim_amplitude;
		}
		v_phase_err_pack = vec4(cos(eff_target), sin(eff_target), cos(eff_shift), sin(eff_shift));
		v_phase_err_anim.xyz = vec3(max(0.0, eff_bleed), max(0.01, eff_selectivity), shift_blend_mult);
	} else {
		v_phase_err_pack = vec4(1.0, 0.0, 1.0, 0.0);
		v_phase_err_anim.xyz = vec3(0.0, 1.0, 1.0);
	}

	v_phase_err_anim.w = 0.0;
	if (power_state < 1.0) {
		float t = clamp((power_flash_start - power_state) / max(0.0001, power_flash_start - power_flash_end), 0.0, 1.0);
		v_phase_err_anim.w = t * t * (3.0 - 2.0 * t) * power_flash_color.a;
	}

	v_warp_power_pack.xy = vec2(1.0 / aspect, aspect);
	v_warp_power_pack.zw = (power_close_axis == 0)
		? vec2(1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001), 1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001))
		: vec2(1.0 / max(smoothstep(0.0, 0.5, power_state), 0.001), 1.0 / max(smoothstep(0.5, 1.0, power_state), 0.001));

	float _degauss = (degauss_progress < 1.0) ? textureLod(degauss_curve, vec2(degauss_progress, 0.0), 0.0).r : 0.0;
	float _wobble = wobble_strength;
	if (animate_wobble) _wobble += textureLod(wobble_curve, vec2(fract(TIME * wobble_anim_speed), 0.0), 0.0).r * wobble_anim_amplitude;
	_wobble += _degauss * degauss_wobble_strength; 

	v_degauss_data = vec4(
		_degauss,
		cos(TIME * TAU * 15.0) * _wobble * 0.0001220703125,
		degauss_bulge_strength * _degauss,
		degauss_ripple_strength * _degauss
	);
	v_extra_data = vec4(
		degauss_tear_strength * _degauss,
		eff_scanlines,
		eff_scanlines / max(bayer_dither_scale, 0.1),
		inv_bw
	);

	v_dyn_pack1.x = (_degauss > 0.0) ? (_degauss * degauss_color_split) : 0.0;
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
	v_dyn_pack2.w = 1.0 / max(mask_scale, 0.01);

	v_dyn_pack3.x = use_echo ? echo_strength : 0.0;
	if (animate_echo_strength && use_echo) {
		if (echo_strength_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_strength_anim_speed);
			float local_t = mod(TIME, active_time + echo_strength_anim_interval);
			if (local_t < active_time) v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(local_t * echo_strength_anim_speed, 0.0), 0.0).r * echo_strength_anim_amplitude;
		} else {
			v_dyn_pack3.x += textureLod(echo_strength_curve, vec2(fract(TIME * echo_strength_anim_speed), 0.0), 0.0).r * echo_strength_anim_amplitude;
		}
	}

	v_dyn_pack3.y = echo_offset;
	if (animate_echo_offset) {
		if (echo_offset_anim_interval > 0.0) {
			float active_time = 1.0 / max(0.001, echo_offset_anim_speed);
			float local_t = mod(TIME, active_time + echo_offset_anim_interval);
			if (local_t < active_time) v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(local_t * echo_offset_anim_speed, 0.0), 0.0).r * echo_offset_anim_amplitude;
		} else {
			v_dyn_pack3.y += textureLod(echo_offset_curve, vec2(fract(TIME * echo_offset_anim_speed), 0.0), 0.0).r * echo_offset_anim_amplitude;
		}
	}

	v_dyn_pack3.z = -1000.0; 
	if (use_vhs_tracking && abs(vhs_tracking_speed) > 0.001) {
		float travel_dist = 1.0 + vhs_tracking_height;
		float abs_speed = abs(vhs_tracking_speed);
		float sweep_time = travel_dist / abs_speed;
		float local_time = mod(TIME, sweep_time + max(0.001, vhs_tracking_interval));
		if (local_time < sweep_time) {
			v_dyn_pack3.z = (vhs_tracking_speed > 0.0) ? (-vhs_tracking_height + local_time * abs_speed) : (1.0 - local_time * abs_speed);
		}
	}

	v_dyn_pack3.w = scanline_brightness;
	if (crt_profile == 1) v_dyn_pack3.w = 0.8;
	else if (crt_profile == 2) v_dyn_pack3.w = 0.4;

	float glitch_time = floor(TIME * 20.0);
	float r1 = fract(sin(glitch_time * 91.2228) * 43758.5453);
	v_glitch_field = vec4(
		fract(sin(glitch_time * 50.481) * 43758.5453),
		step(1.0 - glitch_rate, r1) * (fract(sin(glitch_time * 125.391) * 43758.5453) - 0.5) * v_dyn_pack2.y,
		float(int(TIME * interlaced_fps) & 1),
		TIME * interlaced_jitter_speed
	);

	float t60 = TIME * 60.0;
	float f60 = floor(t60);
	v_time_pack1 = vec4(t60, fract(TIME * 0.2), fract(TIME * 0.1), TIME * dot_crawl_speed);
	v_time_pack2 = vec4(
		TIME * roll_speed,
		fract(sin(f60 * 12.9898) * 43758.5453) * 1000.0,
		fract(sin(f60 * 78.233) * 43758.5453) * 1000.0,
		TIME * 30.0
	);

	if (use_sweep_stripe) {
		float margin = stripe_width * 1.5;
		v_stripe_calc = vec4(
			-margin + fract((TIME * stripe_speed) / stripe_interval + stripe_offset) * (1.0 + (margin * 2.0)),
			cos(stripe_angle),
			sin(stripe_angle),
			1.0 / max(0.0001, stripe_width * 0.5)
		);
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
	col = max(col, vec3(0.0));
	return mix((pow(col, INV_GAMMA) * 1.055) - 0.055, col * 12.92, lessThan(col, vec3(0.0031318)));
}

vec3 srgb_to_linear(vec3 col) {
	col = max(col, vec3(0.0));
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

float bayer4x4(ivec2 p) {
	int x = p.x & 3;
	int y = p.y & 3;
	int idx = ((x ^ y) & 1) * 8 + (y & 1) * 4 + (((x ^ y) >> 1) & 1) * 2 + ((y >> 1) & 1);
	return (float(idx) + 0.5) * 0.0625 - 0.5;
}

vec3 evaluate_false_color(float luma, int mode) {
	float t = clamp(luma * false_color_gain + false_color_offset, 0.0, 1.0);
	if (abs(false_color_gamma - 1.0) > 0.001) t = pow(max(t, 0.0), false_color_gamma);
	if (false_color_invert) t = 1.0 - t;
	if (false_color_steps > 1.5) t = floor(t * false_color_steps) / (false_color_steps - 1.0);
	t = clamp(t, 0.0, 1.0);

	vec3 out_col;
	if (mode == 1) { // FLIR Ironbow
		vec3 c0 = vec3(0.01, 0.0, 0.06);
		vec3 c1 = vec3(0.28, 0.02, 0.52);
		vec3 c2 = vec3(0.85, 0.16, 0.12);
		vec3 c3 = vec3(1.0, 0.78, 0.08);
		vec3 c4 = vec3(1.0, 1.0, 0.96);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.28, t));
		col = mix(col, c2, smoothstep(0.28, 0.56, t));
		col = mix(col, c3, smoothstep(0.56, 0.82, t));
		out_col = mix(col, c4, smoothstep(0.82, 1.0, t));
	} else if (mode == 2) { // White-Hot IR
		out_col = vec3(pow(t, 0.85));
	} else if (mode == 3) { // Black-Hot IR
		out_col = vec3(1.0 - pow(t, 0.85));
	} else if (mode == 4) { // Predator Thermal
		vec3 c0 = vec3(0.02, 0.05, 0.45);
		vec3 c1 = vec3(0.0, 0.75, 0.85);
		vec3 c2 = vec3(0.15, 0.9, 0.2);
		vec3 c3 = vec3(1.0, 0.85, 0.0);
		vec3 c4 = vec3(1.0, 0.08, 0.05);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.25, t));
		col = mix(col, c2, smoothstep(0.25, 0.5, t));
		col = mix(col, c3, smoothstep(0.5, 0.75, t));
		out_col = mix(col, c4, smoothstep(0.75, 1.0, t));
	} else if (mode == 5) { // Phosphor Night-Vision
		float boosted = clamp(pow(t, 0.75) * 1.25, 0.0, 1.0);
		out_col = vec3(boosted * 0.12, boosted, boosted * 0.18) + vec3(smoothstep(0.88, 1.0, t) * 0.65);
	} else if (mode == 6) { // Rainbow / Jet Thermal
		vec3 c0 = vec3(0.0, 0.0, 0.5);
		vec3 c1 = vec3(0.0, 0.7, 1.0);
		vec3 c2 = vec3(0.1, 0.95, 0.25);
		vec3 c3 = vec3(1.0, 0.9, 0.0);
		vec3 c4 = vec3(0.95, 0.05, 0.0);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.25, t));
		col = mix(col, c2, smoothstep(0.25, 0.5, t));
		col = mix(col, c3, smoothstep(0.5, 0.75, t));
		out_col = mix(col, c4, smoothstep(0.75, 1.0, t));
	} else if (mode == 7) { // Arctic / Cryo
		vec3 c0 = vec3(0.01, 0.03, 0.12);
		vec3 c1 = vec3(0.04, 0.24, 0.58);
		vec3 c2 = vec3(0.18, 0.78, 0.95);
		vec3 c3 = vec3(0.92, 0.99, 1.0);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.35, t));
		col = mix(col, c2, smoothstep(0.35, 0.72, t));
		out_col = mix(col, c3, smoothstep(0.72, 1.0, t));
	} else if (mode == 8) { // Inferno / Magma
		vec3 c0 = vec3(0.01, 0.0, 0.03);
		vec3 c1 = vec3(0.32, 0.04, 0.42);
		vec3 c2 = vec3(0.78, 0.16, 0.24);
		vec3 c3 = vec3(0.98, 0.56, 0.06);
		vec3 c4 = vec3(0.99, 0.99, 0.65);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.25, t));
		col = mix(col, c2, smoothstep(0.25, 0.5, t));
		col = mix(col, c3, smoothstep(0.5, 0.78, t));
		out_col = mix(col, c4, smoothstep(0.78, 1.0, t));
	} else if (mode == 9) { // Viridis Scientific
		vec3 c0 = vec3(0.26, 0.01, 0.33);
		vec3 c1 = vec3(0.23, 0.32, 0.54);
		vec3 c2 = vec3(0.13, 0.57, 0.55);
		vec3 c3 = vec3(0.37, 0.79, 0.38);
		vec3 c4 = vec3(0.99, 0.91, 0.14);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.25, t));
		col = mix(col, c2, smoothstep(0.25, 0.5, t));
		col = mix(col, c3, smoothstep(0.5, 0.75, t));
		out_col = mix(col, c4, smoothstep(0.75, 1.0, t));
	} else if (mode == 10) { // Amber Phosphor P3
		float a = pow(t, 0.85);
		out_col = vec3(1.0, 0.48, 0.03) * a + vec3(1.0, 0.88, 0.45) * smoothstep(0.82, 1.0, t) * 0.45;
	} else if (mode == 11) { // Cyan Radar / Sonar
		vec3 c0 = vec3(0.0, 0.03, 0.06);
		vec3 c1 = vec3(0.0, 0.32, 0.48);
		vec3 c2 = vec3(0.08, 0.88, 0.92);
		vec3 c3 = vec3(0.88, 1.0, 1.0);
		vec3 col = mix(c0, c1, smoothstep(0.0, 0.35, t));
		col = mix(col, c2, smoothstep(0.35, 0.78, t));
		out_col = mix(col, c3, smoothstep(0.78, 1.0, t));
	} else { // Exposure / Zebra Monitor
		if (t < 0.06) out_col = vec3(0.08, 0.15, 0.95);
		else if (t > 0.94) out_col = vec3(0.98, 0.06, 0.06);
		else if (t > 0.84) out_col = vec3(0.96, 0.82, 0.05);
		else if (abs(t - 0.52) < 0.04) out_col = vec3(0.12, 0.85, 0.22);
		else out_col = vec3(t);
	}

	if (abs(false_color_hue_shift) > 0.001) {
		out_col = shift_hue(out_col, false_color_hue_shift);
	}
	return out_col;
}

vec3 sample_row_scalar(int ix, int iy, int max_x, float wa, float wb, float wc, float wd, float we) {
	return srgb_to_linear(texelFetch(tex, ivec2(clamp(ix - 2, 0, max_x), iy), 0).rgb) * wa +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix - 1, 0, max_x), iy), 0).rgb) * wb +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix,     0, max_x), iy), 0).rgb) * wc +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix + 1, 0, max_x), iy), 0).rgb) * wd +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix + 2, 0, max_x), iy), 0).rgb) * we;
}

vec3 sample_row_rgb(int ix, int iy, int max_x, vec3 wa, vec3 wb, vec3 wc, vec3 wd, vec3 we) {
	return srgb_to_linear(texelFetch(tex, ivec2(clamp(ix - 2, 0, max_x), iy), 0).rgb) * wa +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix - 1, 0, max_x), iy), 0).rgb) * wb +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix,     0, max_x), iy), 0).rgb) * wc +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix + 1, 0, max_x), iy), 0).rgb) * wd +
	       srgb_to_linear(texelFetch(tex, ivec2(clamp(ix + 2, 0, max_x), iy), 0).rgb) * we;
}

vec3 sample_image(vec2 uv) {
	if (use_interleaved_fields && field_bob_strength > 0.0) {
		uv.y += (v_glitch_field.z - 0.5) * (field_bob_strength / max(v_extra_data.y, 1.0));
	}

	vec2 scaled_uv = uv * v_tex_data.xy;
	int max_x = int(v_tex_data.x) - 1;
	int max_y = int(v_tex_data.y) - 1;
	int ix = clamp(int(floor(scaled_uv.x)), 0, max_x);

	bool has_rgb_split = (v_dyn_pack1.x != 0.0);
	bool fast = (!has_rgb_split && v_dyn_pack1.y >= 0.999);

	float s_wa = 0.0, s_wb = 0.0, s_wc = 0.0, s_wd = 0.0, s_we = 0.0, s_scaler = 0.0;
	vec3 weight_a = vec3(0.0), weight_b = vec3(0.0), weight_c = vec3(0.0), weight_d = vec3(0.0), weight_e = vec3(0.0), weight_scaler_vec = vec3(0.0);

	if (!fast) {
		float diff_base = fract(scaled_uv.x) - 0.5;
		float sh = v_dyn_pack1.y;
		if (!has_rgb_split) {
			s_wa = smoothstep(1.0, 0.0, (diff_base + 2.0) * sh);
			s_wb = smoothstep(1.0, 0.0, (diff_base + 1.0) * sh);
			s_wc = smoothstep(1.0, 0.0, abs(diff_base) * sh);
			s_wd = smoothstep(1.0, 0.0, (1.0 - diff_base) * sh);
			s_we = smoothstep(1.0, 0.0, (2.0 - diff_base) * sh);
			s_scaler = 1.0 / (s_wa + s_wb + s_wc + s_wd + s_we);
		} else {
			vec3 diff = vec3(diff_base - v_dyn_pack1.x, diff_base, diff_base + v_dyn_pack1.x);
			weight_a = smoothstep(vec3(1.0), vec3(0.0), (diff + 2.0) * sh);
			weight_b = smoothstep(vec3(1.0), vec3(0.0), (diff + 1.0) * sh);
			weight_c = smoothstep(vec3(1.0), vec3(0.0), abs(diff) * sh);
			weight_d = smoothstep(vec3(1.0), vec3(0.0), (1.0 - diff) * sh);
			weight_e = smoothstep(vec3(1.0), vec3(0.0), (2.0 - diff) * sh);
			weight_scaler_vec = 1.0 / (weight_a + weight_b + weight_c + weight_d + weight_e);
		}
	}

	float abstract_y = uv.y * v_extra_data.y;
	vec3 result_color;

	if (use_scanlines) {
		float shifted_y = abstract_y - TIME * scanline_drift_speed;
		float y_center1 = floor(shifted_y) + 0.5;
		float diff = fract(shifted_y) - 0.5;
		float y_center2 = y_center1 + (diff < 0.0 ? -1.0 : 1.0);
		
		vec3 rgb_phase = use_rgb_scanline_phase ? vec3(-rgb_scanline_phase_offset, 0.0, rgb_scanline_phase_offset) : vec3(0.0);
		vec3 dist1 = abs(vec3(shifted_y) + rgb_phase - y_center1); 
		vec3 dist2 = abs(vec3(shifted_y) + rgb_phase - y_center2); 
		float blur = max(fwidth(shifted_y), 0.001) * 1.25;

		if (use_decoupled_scanlines) {
			float sample_res = decoupled_use_native_res ? v_tex_data.y : decoupled_vertical_res;
			float tex_y = (floor(uv.y * sample_res) + 0.5) / sample_res * v_tex_data.y;
			int iy = clamp(int(floor(tex_y)), 0, max_y);
			
			vec3 raw_color = fast
				? srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb)
				: (!has_rgb_split
					? sample_row_scalar(ix, iy, max_x, s_wa, s_wb, s_wc, s_wd, s_we) * s_scaler
					: sample_row_rgb(ix, iy, max_x, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec);
			
			vec3 col = raw_color * v_dyn_pack3.w;
			vec3 thick = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), decoupled_dynamic_thickness ? col : vec3(1.0));
			
			vec3 beam1 = smoothstep(thick * 0.5 + blur, thick * 0.5 - blur, dist1);
			vec3 beam2 = smoothstep(thick * 0.5 + blur, thick * 0.5 - blur, dist2);
			
			int field_glitch = int(v_glitch_field.z);
			beam1 *= 1.0 - float((int(y_center1) & 1) ^ field_glitch) * v_dyn_pack1.w;
			beam2 *= 1.0 - float((int(y_center2) & 1) ^ field_glitch) * v_dyn_pack1.w;
			
			vec3 final_lines = mix(raw_color, col * (beam1 + beam2), decoupled_beam_opacity);
			result_color = (scanline_cutoff > 0.0)
				? mix(raw_color, final_lines, smoothstep(0.0, scanline_cutoff, dot(raw_color, vec3(0.333))))
				: final_lines;
		} else {
			float tex_y1 = y_center1 + TIME * scanline_drift_speed;
			float tex_y2 = y_center2 + TIME * scanline_drift_speed;
			int iy1 = clamp(int(floor((tex_y1 / v_extra_data.y) * v_tex_data.y)), 0, max_y);
			int iy2 = clamp(int(floor((tex_y2 / v_extra_data.y) * v_tex_data.y)), 0, max_y);

			vec3 raw1, raw2;
			if (fast) {
				raw1 = srgb_to_linear(texelFetch(tex, ivec2(ix, iy1), 0).rgb);
				raw2 = srgb_to_linear(texelFetch(tex, ivec2(ix, iy2), 0).rgb);
			} else if (!has_rgb_split) {
				raw1 = sample_row_scalar(ix, iy1, max_x, s_wa, s_wb, s_wc, s_wd, s_we) * s_scaler;
				raw2 = sample_row_scalar(ix, iy2, max_x, s_wa, s_wb, s_wc, s_wd, s_we) * s_scaler;
			} else {
				raw1 = sample_row_rgb(ix, iy1, max_x, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
				raw2 = sample_row_rgb(ix, iy2, max_x, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec;
			}

			vec3 col1 = raw1 * v_dyn_pack3.w;
			vec3 col2 = raw2 * v_dyn_pack3.w;
			vec3 thick1 = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), col1);
			vec3 thick2 = mix(vec3(scanline_beam_width_min), vec3(scanline_beam_width_max), col2);
			
			vec3 profile1 = smoothstep(thick1 * 0.5 + blur, thick1 * 0.5 - blur, dist1) * col1;
			vec3 profile2 = smoothstep(thick2 * 0.5 + blur, thick2 * 0.5 - blur, dist2) * col2;
			
			int field_glitch = int(v_glitch_field.z);
			profile1 *= 1.0 - float((int(y_center1) & 1) ^ field_glitch) * v_dyn_pack1.w;
			profile2 *= 1.0 - float((int(y_center2) & 1) ^ field_glitch) * v_dyn_pack1.w;

			vec3 final_lines = profile1 + profile2;
			result_color = (scanline_cutoff > 0.0)
				? mix(raw1, final_lines, smoothstep(0.0, scanline_cutoff, dot(raw1, vec3(0.333))))
				: final_lines;
		}
	} else {
		int iy = clamp(int(floor(scaled_uv.y)), 0, max_y);
		vec3 color = fast
			? srgb_to_linear(texelFetch(tex, ivec2(ix, iy), 0).rgb)
			: (!has_rgb_split
				? sample_row_scalar(ix, iy, max_x, s_wa, s_wb, s_wc, s_wd, s_we) * s_scaler
				: sample_row_rgb(ix, iy, max_x, weight_a, weight_b, weight_c, weight_d, weight_e) * weight_scaler_vec);
		
		if (v_dyn_pack1.w > 0.0) {
			int abstract_iy = int(floor(abstract_y));
			color *= 1.0 - float((abstract_iy & 1) ^ int(v_glitch_field.z)) * v_dyn_pack1.w;
		}
		result_color = color;
	}

	if (use_interleaved_fields && field_line_blanking > 0.0) {
		int line_parity = int(floor(abstract_y)) & 1;
		result_color *= 1.0 - float(line_parity ^ int(v_glitch_field.z)) * field_line_blanking;
	}

	return result_color;
}

vec3 mask(vec3 linear_color, vec2 coords) {
	if (mask_type == 0) {
		return linear_color * mix(0.5, 1.0, v_dyn_pack1.z);
	}

	vec3 m_rgb = vec3(0.5);
	float m_w = 0.5;
	float cx = coords.x * TWO_THIRD_PI;

	switch (mask_type) {
		case 1: 
			m_rgb = (0.5 + 0.5 * cos(cx - PHASE_OFFSETS)) * (0.5 + 0.5 * cos(coords.y * PI));
			m_w = 0.25;
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
			m_rgb = (0.5 + 0.5 * cos(cx - PHASE_OFFSETS)) * (0.5 + 0.5 * cos((coords.y + (0.5 - 0.5 * cos(cx)) * 0.5) * TAU));
			m_w = 0.375;
			break;
		case 6: 
			m_rgb = vec3(1.0);
			m_w = mix(1.0, 0.6, clamp(0.5 + 1.5 * cos(cx), 0.0, 1.0)); 
			break;
		case 7:
			m_rgb = clamp(0.5 + 1.5 * cos(cx - PHASE_OFFSETS), 0.0, 1.0);
			m_w = 0.6;
			break;
		case 8:
			m_rgb = clamp(0.5 + 1.5 * cos(cx - PHASE_OFFSETS), 0.0, 1.0) * clamp(0.5 + 1.5 * cos(coords.y * TAU), 0.0, 1.0);
			m_w = 0.6;
			break;
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
	vec3 highlights = (m_w < 0.999) ? ((target_color - primary_col) * (m_w / (1.0 - m_w))) : vec3(0.0);
	
	return primary_col * m_rgb + highlights * (1.0 - m_rgb);
}

void fragment() {
	float fw_x = max(fwidth(UV.x), 0.0001);
	float fw_y = max(fwidth(UV.y), 0.0001);
	vec2 warped_coords = warp(UV);
	
	if (power_state < 0.001 || warped_coords.x < 0.0 || warped_coords.x > 1.0 || warped_coords.y < 0.0 || warped_coords.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		float quad_aspect = fw_y / fw_x;
		vec2 quad_pixels = vec2(1.0 / fw_x, 1.0 / fw_y);
		vec2 aspect_coords = vec2(warped_coords.x * quad_aspect, warped_coords.y);

		warped_coords.x += v_degauss_data.y;

		float in_v_blank = 0.0;
		if (use_v_blanking) {
			float v_bar_y = fract(warped_coords.y - TIME * v_blanking_speed);
			if (v_bar_y < v_blanking_bar_size) {
				in_v_blank = 1.0;
			} else if (v_blanking_tearing > 0.0) {
				float tear_dist = v_bar_y - v_blanking_bar_size;
				warped_coords.x += exp(-20.0 * tear_dist) * sin(tear_dist * 50.0) * v_blanking_tearing;
			}
		}

		float crease_factor = 0.0;
		if (use_tape_crease) {
			float travel_distance = 1.0 + (crease_width * 2.0);
			float active_time = travel_distance / max(0.001, crease_speed);
			float local_t = mod(TIME, active_time + crease_interval);
			if (local_t < active_time) {
				float c_pos = -crease_width + (local_t * crease_speed);
				float dist = abs(warped_coords.y - c_pos);
				crease_factor = smoothstep(crease_width, crease_width * 0.2, dist);
				if (crease_factor > 0.0 && crease_noise_strength > 0.0) {
					float crease_noise = value_noise_1(vec2(aspect_coords.y * 100.0, TIME * 20.0));
					warped_coords.x += (crease_noise - 0.5) * crease_factor * crease_noise_strength * 0.1;
				}
			}
		}

		if (use_edge_wobble && edge_wobble_strength > 0.0) {
			float wobble_noise = value_noise_1(vec2(aspect_coords.y * edge_wobble_scale, TIME * edge_wobble_speed));
			warped_coords.x += (wobble_noise - 0.5) * edge_wobble_strength;
		}

		float head_switch_t = 0.0;
		if (use_head_switching) {
			float switch_start = 1.0 - head_switch_height;
			if (warped_coords.y > switch_start) {
				head_switch_t = (warped_coords.y - switch_start) / max(0.0001, head_switch_height);
				if (head_switch_strength != 0.0) {
					float curve_power = pow(head_switch_t, head_switch_curve);
					float jitter = value_noise_1(vec2(aspect_coords.y * 100.0, TIME * 15.0));
					warped_coords.x += curve_power * head_switch_strength * (0.8 + 0.4 * jitter);
				}
			}
		}

		if (use_interlaced_jitter && interlaced_jitter_strength > 0.0) {
			float row_id = floor(warped_coords.y * v_extra_data.y);
			float jitter_mod = sin(v_glitch_field.w + row_id * interlaced_jitter_frequency);
			if (interlaced_jitter_random) {
				jitter_mod *= fract(sin(row_id * 12.9898 + TIME) * 43758.5453);
			}
			warped_coords.x += ((int(row_id) & 1) == 0 ? jitter_mod : -jitter_mod) * interlaced_jitter_strength;
		}
		
		if (use_h_sync_loss && h_sync_strength > 0.0) {
			float h_sync_noise = value_noise_1(vec2(TIME * h_sync_speed, 0.0));
			float h_sync_mask = smoothstep(h_sync_threshold, h_sync_threshold + 0.1, h_sync_noise);
			if (h_sync_mask > 0.0) {
				float skew = fract(warped_coords.y * h_sync_frequency + TIME * 5.0) - 0.5;
				warped_coords.x += skew * h_sync_strength * h_sync_mask;
			}
		}

		if (use_hsync_tbc_jitter && hsync_tbc_jitter_strength > 0.0) {
			float tbc_line = floor(warped_coords.y * v_extra_data.y);
			float tbc_rand = hash12(vec2(tbc_line, floor(TIME * hsync_tbc_jitter_speed) * 3.17)) - 0.5;
			warped_coords.x += tbc_rand * hsync_tbc_jitter_strength;
		}

		float track_snow = 0.0;
		if (v_dyn_pack3.z > -999.0) {
			float track_band = step(v_dyn_pack3.z, warped_coords.y) * step(warped_coords.y, v_dyn_pack3.z + vhs_tracking_height);
			if (track_band > 0.0) {
				float track_row = floor(aspect_coords.y * vhs_tracking_noise_scale);
				float pseudo_rand = fract(sin(track_row + TIME * 10.0) * 43758.5453);
				warped_coords.x += (pseudo_rand - 0.5) * vhs_tracking_strength * 0.2;
				if (vhs_tracking_snow && vhs_tracking_snow_strength > 0.0) {
					float snow_x = floor(warped_coords.x * mix(180.0, 12.0, vhs_tracking_snow_anisotropy));
					float snow_line = floor(warped_coords.y * v_extra_data.y);
					float snow_rnd = hash12(vec2(snow_x + floor(v_time_pack1.x) * 19.31, snow_line));
					float snow_env = sin(((warped_coords.y - v_dyn_pack3.z) / max(vhs_tracking_height, 0.0001)) * PI);
					track_snow = (smoothstep(0.76, 0.99, snow_rnd) - smoothstep(0.24, 0.01, snow_rnd) * 0.65) * snow_env * vhs_tracking_snow_strength;
				}
			}
		}
		
		if (v_degauss_data.x > 0.0) {
			vec2 center_offset = warped_coords - 0.5;
			float dist = length(center_offset);
			float bulge = sin(dist * 20.0 - v_time_pack1.x) * v_degauss_data.z;
			float ripple = sin(dist * 50.0 - v_time_pack2.w) * v_degauss_data.w;
			warped_coords += center_offset * (bulge + ripple);
			float tear_dy = warped_coords.y - v_time_pack1.y;
			warped_coords.x += exp(-50.0 * tear_dy * tear_dy) * sin(warped_coords.y * 100.0) * v_extra_data.x;
		}

		if (v_dyn_pack2.y > 0.0) {
			warped_coords.x += step(abs(warped_coords.y - v_glitch_field.x), glitch_size) * v_glitch_field.y;
		}
		if (vsync_tearing > 0.0) {
			float tear_dist = warped_coords.y - v_time_pack1.z;
			warped_coords.x += exp(-100.0 * tear_dist * tear_dist) * sin(warped_coords.y * 150.0) * vsync_tearing;
		}

		if (use_datamosh_stretch && datamosh_rate > 0.0 && datamosh_stretch_amount > 0.0) {
			float mosh_band = floor(warped_coords.y * datamosh_band_scale);
			float mosh_t = floor(TIME * datamosh_speed);
			float mosh_rnd = hash12(vec2(mosh_band, mosh_t * 17.31));
			if (mosh_rnd > (1.0 - datamosh_rate)) {
				float anchor_x = hash12(vec2(mosh_band + 9.1, mosh_t * 31.7));
				warped_coords.x = mix(warped_coords.x, anchor_x, datamosh_stretch_amount);
			}
		}

		vec3 macroblock_iq_glitch = vec3(0.0);
		if (use_macroblock_bitrot && macroblock_rate > 0.0) {
			vec2 block_grid = vec2(macroblock_scale * quad_aspect, macroblock_scale);
			vec2 block_id = floor(warped_coords * block_grid);
			float block_t = floor(TIME * macroblock_speed);
			vec3 block_rnd = hash32(block_id + vec2(block_t * 11.13, block_t * 29.71));
			if (block_rnd.x > (1.0 - macroblock_rate)) {
				warped_coords = clamp(warped_coords + (block_rnd.yz - 0.5) * macroblock_uv_shift, vec2(0.0), vec2(0.9999));
				macroblock_iq_glitch = vec3(1.0, (block_rnd.y - 0.5) * macroblock_chroma_shift, (block_rnd.z - 0.5) * macroblock_chroma_shift);
			}
		}

		float stripe_factor = 0.0;
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
					stripe_factor = (stripe_profile == 0) ? (t * t * (3.0 - 2.0 * t)) : ((0.5 + 0.5 * cos(norm_dist * PI)) * t);
				}
			}
		}

		vec3 col = sample_image(warped_coords);
		
		if (in_v_blank > 0.0) col = vec3(0.0);
		if (track_snow != 0.0) col = clamp(col + vec3(track_snow), 0.0, 1.0);
		if (use_analog_clipping) col = clamp((col + analog_pedestal) * analog_gain, 0.0, 1.0);

		float inv_bw = v_extra_data.w;
		float bw_freq = use_bandwidth_scale ? bandwidth_scale : 1.0;

		bool need_yiq = use_yiq_bleed || use_vertical_chroma_smear || use_vertical_chroma_delay || use_tape_noise || use_color_killer || use_yc_delay || use_tape_crease || use_vhs_tape_speed || use_vhs_sharpen || use_luma_smear || (use_fm_slew_rate && fm_slew_rate_mix > 0.0) || (use_chroma_heterodyne_beat && chroma_beat_strength > 0.0) || (macroblock_iq_glitch.x > 0.0) || use_chroma_dropout || use_chroma_demod || use_chroma_phase_error || (use_chroma_demod_axis_error && abs(chroma_demod_axis_skew) > 0.001) || (use_chroma_gain_ripple && chroma_gain_ripple_strength > 0.0) || (use_scanline_phase_noise && scanline_phase_noise_strength > 0.0) || (use_head_switching && head_switch_color_recovery && head_switch_t > 0.0);
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

			if (use_fm_slew_rate && fm_slew_rate_mix > 0.0) {
				float slew_dx = v_tex_data.z * inv_bw;
				float y_prev2 = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(slew_dx * 2.0, 0.0), 0.0).rgb), HUE_LUMA);
				float y_prev1 = dot(srgb_to_linear(textureLod(tex, warped_coords - vec2(slew_dx, 0.0), 0.0).rgb), HUE_LUMA);
				float step1 = y_prev2 + clamp(y_prev1 - y_prev2, -fm_slew_rate_limit, fm_slew_rate_limit);
				float slewed_y = step1 + clamp(final_y - step1, -fm_slew_rate_limit, fm_slew_rate_limit);
				final_y = mix(final_y, slewed_y, fm_slew_rate_mix);
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
				vec3 delayed_col = sample_image(warped_coords - vec2(yc_delay_amount * v_tex_data.z, 0.0));
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
				vec3 rgb2 = (abs(offset) < 0.000001) ? raw_col : srgb_to_linear(textureLod(tex, warped_coords + vec2(offset, 0.0), 0.0).rgb);
				vec3 rgb3 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset + spread, 0.0), 0.0).rgb);
				vec3 rgb4 = srgb_to_linear(textureLod(tex, warped_coords + vec2(offset + spread * 2.0, 0.0), 0.0).rgb);

				vec3 blurred_rgb = (yiq_bleed_filter == 0)
					? ((rgb0 + rgb4) * 0.0625 + (rgb1 + rgb3) * 0.25 + rgb2 * 0.375)
					: (-(rgb0 + rgb4) * 0.085 + (rgb1 + rgb3) * 0.345 + rgb2 * 0.48);
				vec3 blurred_yiq = rgb_to_yiq(blurred_rgb);

				if (use_asymmetric_yiq_bleed && yiq_q_bleed_multiplier > 1.001) {
					float q_blend = clamp((yiq_q_bleed_multiplier - 1.0) * 0.25, 0.0, 1.0);
					vec3 wide_rgb = (yiq_bleed_filter == 0)
						? ((rgb0 + rgb4) * 0.16 + (rgb1 + rgb3) * 0.22 + rgb2 * 0.24)
						: (-(rgb0 + rgb4) * 0.06 + (rgb1 + rgb3) * 0.36 + rgb2 * 0.40);
					blurred_yiq.z = mix(blurred_yiq.z, rgb_to_yiq(wide_rgb).z, q_blend);
				}

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

			if (use_vertical_chroma_delay && chroma_line_delay_mix > 0.0) {
				vec3 prev_line_yiq = rgb_to_yiq(srgb_to_linear(textureLod(tex, warped_coords - vec2(0.0, v_tex_data.w), 0.0).rgb));
				final_i = mix(final_i, (final_i + prev_line_yiq.y) * 0.5, chroma_line_delay_mix);
				final_q = mix(final_q, (final_q + prev_line_yiq.z) * 0.5, chroma_line_delay_mix);
			}

			if (use_chroma_demod_axis_error && abs(chroma_demod_axis_skew) > 0.001) {
				final_q = final_q * cos(chroma_demod_axis_skew) + final_i * sin(chroma_demod_axis_skew);
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

			if (use_chroma_gain_ripple && chroma_gain_ripple_strength > 0.0) {
				float ripple_wave = sin(warped_coords.y * chroma_gain_ripple_freq * TAU - TIME * chroma_gain_ripple_speed);
				float ripple_gain = max(0.0, 1.0 + ripple_wave * chroma_gain_ripple_strength);
				final_i *= ripple_gain;
				final_q *= ripple_gain;
			}

			if (use_chroma_heterodyne_beat && chroma_beat_strength > 0.0) {
				float sat_amp = length(vec2(final_i, final_q));
				if (sat_amp > 0.001) {
					float beat_phase = (aspect_coords.x * 1.732 + aspect_coords.y) * chroma_beat_frequency * TAU - TIME * chroma_beat_speed;
					float beat_mod = sat_amp * chroma_beat_strength;
					final_i += sin(beat_phase) * beat_mod;
					final_q += cos(beat_phase) * beat_mod;
				}
			}

			if (macroblock_iq_glitch.x > 0.0) {
				final_i += macroblock_iq_glitch.y;
				final_q += macroblock_iq_glitch.z;
			}

			if (use_head_switching && head_switch_color_recovery && head_switch_t > 0.0 && (abs(head_switch_hue_twist) > 0.001 || head_switch_sat_spike > 0.0)) {
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

			if (use_color_killer && color_killer_threshold > 0.0) {
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

		bool need_l1_r1 = use_signal_ringing || use_dot_crawl || use_cross_color || use_cross_luminance || (use_luma_notch_bleed && luma_notch_bleed_strength > 0.0) || use_pre_emphasis || (use_deemphasis_mismatch && abs(deemphasis_mismatch_gain) > 0.001) || (use_composite_sharpening && abs(composite_sharpening) > 0.001);
		if (need_l1_r1) {
			float tap_dx = v_tex_data.z * inv_bw;
			vec3 l1 = sample_image(warped_coords - vec2(tap_dx, 0.0));
			vec3 r1 = sample_image(warped_coords + vec2(tap_dx, 0.0));
			float luma_left = dot(l1, HUE_LUMA);
			float luma_right = dot(r1, HUE_LUMA);

			float sub_line_phase = 0.0;
			if (use_subcarrier_line_phase) {
				float line_idx = floor(warped_coords.y * v_extra_data.y);
				float step_rad = float(subcarrier_line_phase_step) * 1.5707963;
				float frame_flip = subcarrier_frame_alternate ? (float(int(v_time_pack1.x) & 1) * PI) : 0.0;
				sub_line_phase = line_idx * step_rad + frame_flip + subcarrier_phase_offset;
			}

			if (use_composite_sharpening && abs(composite_sharpening) > 0.001) {
				vec3 comp_detail = col - (l1 + r1) * 0.5;
				col = clamp(col + comp_detail * composite_sharpening, 0.0, 1.0);
			}

			if (use_pre_emphasis && pre_emphasis_strength > 0.0) {
				float l_center = dot(col, HUE_LUMA);
				float hf_luma = l_center * 2.0 - luma_left - luma_right;
				float edge_gate = smoothstep(pre_emphasis_cutoff, pre_emphasis_cutoff + 0.15, abs(hf_luma));
				col = clamp(col + vec3(hf_luma * pre_emphasis_strength * edge_gate), 0.0, 1.0);
			}

			if (use_deemphasis_mismatch && abs(deemphasis_mismatch_gain) > 0.001) {
				float trail_dx = deemphasis_decay_pixels * v_tex_data.z * inv_bw;
				vec3 trail_col = srgb_to_linear(textureLod(tex, warped_coords - vec2(trail_dx, 0.0), 0.0).rgb);
				float trail_delta = dot(col - trail_col, HUE_LUMA);
				col = clamp(col + vec3(trail_delta * deemphasis_mismatch_gain), 0.0, 1.0);
			}
			
			if (use_signal_ringing && ringing_strength > 0.0) {
				vec3 l2 = sample_image(warped_coords - vec2(tap_dx * 2.0, 0.0));
				vec3 r2 = sample_image(warped_coords + vec2(tap_dx * 2.0, 0.0));
				vec3 ringing_kernel = (col * 2.0 - l1 - r1) - 0.5 * (l2 + r2 - 2.0 * col);
				col += ringing_kernel * ringing_strength;
			}
			
			if (use_cross_color && cross_color_strength > 0.0) {
				float l_center = dot(col, HUE_LUMA);
				float hf_signal = abs(l_center * 2.0 - luma_left - luma_right);
				float moire_mask = smoothstep(cross_color_threshold, cross_color_threshold + 0.2, hf_signal);
				
				if (moire_mask > 0.0) {
					float moire_phase = use_subcarrier_line_phase
						? (warped_coords.x * (v_extra_data.y * aspect) * PI * bw_freq + sub_line_phase)
						: (warped_coords.x * (v_extra_data.y * aspect) * 3.14159 * bw_freq + warped_coords.y * v_extra_data.y * 1.57079 - TIME * 15.0);
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
				float luma_diff = abs(luma_left - luma_right);
				
				float zipper_mask = smoothstep(0.05, 0.2, chroma_diff) * (1.0 - smoothstep(0.0, 0.1, luma_diff));
				if (zipper_mask > 0.0) {
					float zipper_phase = warped_coords.y * v_extra_data.y * 3.14159 * bw_freq - TIME * 15.0;
					vec3 center_yiq = rgb_to_yiq(col);
					center_yiq.x += sin(zipper_phase) * zipper_mask * cross_luminance_strength * 0.5;
					col = yiq_to_rgb(center_yiq);
				}
			}

			if (use_luma_notch_bleed && luma_notch_bleed_strength > 0.0) {
				vec3 notch_yiq = rgb_to_yiq(col);
				float chroma_amp = length(notch_yiq.yz);
				if (chroma_amp > 0.001) {
					float notch_phase = use_subcarrier_line_phase
						? (warped_coords.x * (v_extra_data.y * aspect) * PI * bw_freq + sub_line_phase)
						: (warped_coords.x * (v_extra_data.y * aspect) * PI * bw_freq + warped_coords.y * v_extra_data.y * PI - v_time_pack1.w);
					col = clamp(col + vec3(sin(notch_phase) * chroma_amp * luma_notch_bleed_strength), 0.0, 1.0);
				}
			}
			
			if (use_dot_crawl && dot_crawl_strength > 0.0) {
				float edge_intensity = abs(luma_right - luma_left);
				float edge_mask = smoothstep(dot_crawl_threshold, dot_crawl_threshold + 0.1, edge_intensity);
				vec2 dot_crawl_coords = warped_coords * quad_pixels;
				float pattern = use_subcarrier_line_phase
					? sin(dot_crawl_coords.x * PI * bw_freq + sub_line_phase + v_time_pack1.w)
					: (sin(dot_crawl_coords.x * PI * bw_freq) * sin(dot_crawl_coords.y * PI + v_time_pack1.w));
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
			float drift = sin(TIME * phase_drift_speed) * phase_drift_strength;
			float phase_mod = ((int(line_idx) & 1) == 0) ? drift : -drift;
			col = shift_hue(col, phase_mod);
		}

		if (use_sweep_stripe && stripe_factor > 0.0) {
			if (stripe_enable_hue) {
				float current_hue = stripe_hue_shift;
				if (stripe_hue_oscillate) {
					float spatial_coord = ((stripe_hue_osc_axis == 1) ? rotated_uv.x : rotated_uv.y) * stripe_hue_osc_scale;
					float osc_val = evaluate_wave(stripe_hue_osc_profile, (spatial_coord + stripe_hue_osc_offset) * stripe_hue_osc_freq + TIME * stripe_hue_osc_speed);
					current_hue += mix(stripe_hue_osc_min, stripe_hue_osc_max, osc_val) * stripe_hue_osc_intensity;
				}
				col = shift_hue(col, current_hue * stripe_factor);
			}
			if (stripe_enable_secondary_hue) {
				float current_secondary_hue = stripe_secondary_hue_shift;
				float current_mix_factor = stripe_secondary_mix * stripe_factor;
				if (stripe_secondary_wave_enabled) {
					float spatial_coord = ((stripe_secondary_wave_axis == 0) ? rotated_uv.x : rotated_uv.y) * stripe_secondary_wave_scale;
					float wave_val = evaluate_wave(stripe_secondary_wave_profile, (spatial_coord + stripe_secondary_wave_offset) * stripe_secondary_wave_freq + TIME * stripe_secondary_wave_speed);
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
		if (v_dyn_pack2.x > 0.0) col *= 1.0 + smoothstep(0.8, 1.0, sin(warped_coords.y * roll_size - v_time_pack2.x)) * v_dyn_pack2.x;

		if (use_vector_edge_glow && vector_edge_strength > 0.0) {
			vec3 vec_r = srgb_to_linear(textureLod(tex, warped_coords + vec2(v_tex_data.z, 0.0), 0.0).rgb);
			vec3 vec_d = srgb_to_linear(textureLod(tex, warped_coords + vec2(0.0, v_tex_data.w), 0.0).rgb);
			float edge_grad = length(col - vec_r) + length(col - vec_d);
			float beam_boost = smoothstep(vector_edge_threshold, vector_edge_threshold + 0.25, edge_grad);
			col += vector_edge_color * beam_boost * vector_edge_strength;
		}

		if (use_halation && halation_strength > 0.0) {
			vec2 hal_off = vec2(halation_radius / max(quad_aspect, 0.001), halation_radius) * v_tex_data.zw;
			vec3 h1 = srgb_to_linear(textureLod(tex, warped_coords + vec2(hal_off.x, hal_off.y), 0.0).rgb);
			vec3 h2 = srgb_to_linear(textureLod(tex, warped_coords + vec2(-hal_off.x, hal_off.y), 0.0).rgb);
			vec3 h3 = srgb_to_linear(textureLod(tex, warped_coords + vec2(hal_off.x, -hal_off.y), 0.0).rgb);
			vec3 h4 = srgb_to_linear(textureLod(tex, warped_coords + vec2(-hal_off.x, -hal_off.y), 0.0).rgb);
			vec3 hal_avg = (h1 + h2 + h3 + h4) * 0.25;
			float hal_luma = dot(hal_avg, HUE_LUMA);
			float hal_mask = smoothstep(halation_threshold, min(1.0, halation_threshold + 0.35), hal_luma);
			col += halation_color * hal_mask * halation_strength;
		}

		if (use_anamorphic_streak && anamorphic_streak_strength > 0.0) {
			float str_dx = anamorphic_streak_length * v_tex_data.z;
			vec3 s1 = srgb_to_linear(textureLod(tex, warped_coords - vec2(str_dx * 0.4, 0.0), 0.0).rgb);
			vec3 s2 = srgb_to_linear(textureLod(tex, warped_coords + vec2(str_dx * 0.4, 0.0), 0.0).rgb);
			vec3 s3 = srgb_to_linear(textureLod(tex, warped_coords - vec2(str_dx, 0.0), 0.0).rgb);
			vec3 s4 = srgb_to_linear(textureLod(tex, warped_coords + vec2(str_dx, 0.0), 0.0).rgb);
			vec3 streak_avg = (s1 + s2) * 0.32 + (s3 + s4) * 0.18;
			float streak_luma = dot(streak_avg, HUE_LUMA);
			float streak_mask = smoothstep(anamorphic_threshold, min(1.0, anamorphic_threshold + 0.3), streak_luma);
			col += anamorphic_streak_color * streak_mask * anamorphic_streak_strength;
		}

		if (use_rf_snow && rf_snow_intensity > 0.0) {
			float inv_snow_scale = 1.0 / max(rf_snow_scale, 0.05);
			float snow_lines = v_extra_data.y * inv_snow_scale;
			float rf_x = floor(warped_coords.x * (snow_lines * quad_aspect) * mix(1.0, 0.065, rf_snow_anisotropy));
			float rf_y = floor(warped_coords.y * snow_lines);
			float rf_rnd = hash12(vec2(rf_x + floor(TIME * rf_snow_speed) * 23.71, rf_y));
			float rf_burst = smoothstep(0.84, 0.995, rf_rnd) - smoothstep(0.16, 0.005, rf_rnd) * 0.6;
			col = clamp(col + vec3(rf_burst * rf_snow_intensity), 0.0, 1.0);
		}

		if (v_dyn_pack2.z > 0.0) {
			vec2 noise_coords = (warped_coords * quad_pixels) * (noise_base_scale * 0.05) + v_time_pack2.yz;
			vec3 noise_val = chroma_noise
				? fbm_3(noise_coords, noise_octaves, noise_lacunarity, noise_gain)
				: vec3(fbm_1(noise_coords, noise_octaves, noise_lacunarity, noise_gain));
			col += (noise_val - 0.5) * v_dyn_pack2.z;
		}
		
		if (use_tape_dropouts && dropout_rate > 0.0 && dropout_strength > 0.0) {
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

		if (use_solarization && solarization_mix > 0.0) {
			vec3 sol = 1.0 - abs(col - vec3(solarization_threshold)) / max(solarization_threshold, 1.0 - solarization_threshold);
			col = mix(col, clamp(sol, 0.0, 1.0), solarization_mix);
		}

		col = mask(col, warped_coords * quad_pixels * v_dyn_pack2.w);

		if (use_auto_exposure && exposure_intensity > 0.0) {
			float luma = dot(col, HUE_LUMA);
			col = mix(col, vec3(1.0), smoothstep(exposure_threshold, 1.0, luma) * exposure_intensity);
		}
		if (use_bayer_dither && bayer_dither_spread > 0.0) {
			float dither_luma = dot(col, HUE_LUMA);
			float luma_gate = smoothstep(bayer_dither_min_luma, min(1.0, bayer_dither_min_luma + bayer_dither_fade_range), dither_luma);
			if (luma_gate > 0.0) {
				float dither_res = v_extra_data.z;
				ivec2 dither_cell = ivec2(floor(vec2(warped_coords.x * (dither_res * quad_aspect), warped_coords.y * dither_res)));
				vec3 dithered = clamp(col + vec3(bayer4x4(dither_cell) * bayer_dither_spread * luma_gate), 0.0, 1.0);
				if (bayer_dither_levels > 1.5) {
					vec3 snapped = floor(dithered * bayer_dither_levels + 0.5) / bayer_dither_levels;
					dithered = mix(col, snapped, luma_gate);
				}
				col = dithered;
			}
		}
		if (use_color_quantization) col = floor(col * color_levels) / color_levels;
		if (use_gradient_map) {
			float luma = dot(col, HUE_LUMA);
			col = textureLod(gradient_texture, vec2(clamp(luma, 0.0, 1.0), 0.0), 0.0).rgb;
		}
		if (false_color_mode > 0 && false_color_mix > 0.0) {
			float luma = dot(col, HUE_LUMA);
			col = mix(col, evaluate_false_color(luma, false_color_mode), false_color_mix);
		}
		if (use_vfd_display) {
			float luma = dot(col, HUE_LUMA);
			vec2 grid_uv = aspect_coords * vfd_mesh_scale;
			float diag1 = abs(fract(grid_uv.x + grid_uv.y) - 0.5) * 2.0;
			float diag2 = abs(fract(grid_uv.x - grid_uv.y) - 0.5) * 2.0;
			float wire_mask = smoothstep(0.84, 0.96, max(diag1, diag2));
			vec3 vfd_col = vfd_phosphor_color * (luma + (luma * luma) * vfd_glow_strength);
			vfd_col *= 1.0 - wire_mask * vfd_mesh_strength;
			col = clamp(vfd_col, 0.0, 1.0);
		}
		if (use_monochrome) {
			float luma = dot(col, HUE_LUMA);
			col = monochrome_color.rgb * luma;
		}
		if (use_motion_persistence && persistence_strength > 0.0) {
			vec3 prev_col = srgb_to_linear(textureLod(previous_frame_tex, warped_coords, 0.0).rgb);
			col = mix(col, prev_col, persistence_strength);
		}

		if (use_hum_bar && hum_bar_strength > 0.0) {
			float hum = 0.5 + 0.5 * sin(warped_coords.y * 10.0 - TIME * hum_bar_speed);
			col *= 1.0 - (hum * hum_bar_strength);
		}
		if (use_glare && glare_strength > 0.0) {
			vec2 centered = warped_coords - glare_position;
			float gc = cos(glare_rotation);
			float gs = sin(glare_rotation);
			float rot_x = gc * centered.x - gs * centered.y;
			float glare = smoothstep(glare_size + glare_softness, glare_size, abs(rot_x));
			col += vec3(glare * glare_strength);
		}
		if (use_glass_reflection && glass_env_strength > 0.0 && glass_tint.a > 0.0) {
			vec2 env_uv = warped_coords - 0.5;
			if (glass_curve > 0.0) {
				env_uv.x *= v_warp_power_pack.x;
				env_uv /= 1.0 - glass_curve * (dot(env_uv, env_uv) - 0.25);
				env_uv.x *= v_warp_power_pack.y;
			}
			env_uv = (env_uv / max(0.001, glass_env_scale)) + (0.5 + glass_env_offset);
			
			vec3 env = srgb_to_linear(textureLod(glass_env_tex, env_uv, glass_blur).rgb) * (glass_tint.rgb * glass_brightness);
			if (abs(glass_saturation - 1.0) > 0.001) {
				env = mix(vec3(dot(env, HUE_LUMA)), env, glass_saturation);
			}
			
			vec3 blended;
			if (glass_blend_mode == 0) blended = col + env;
			else if (glass_blend_mode == 1) blended = 1.0 - (1.0 - col) * (1.0 - env);
			else blended = max(col, env);
			
			col = mix(col, blended, glass_env_strength * glass_tint.a);
		}
		if (bezel_shadow_strength > 0.0) {
			vec2 edge_dist = abs(warped_coords - 0.5) * 2.0;
			float shadow = smoothstep(1.0 - bezel_shadow_width, 1.0, max(edge_dist.x, edge_dist.y));
			col *= 1.0 - (shadow * bezel_shadow_strength);
		}
		
		if (v_phase_err_anim.w > 0.0) {
			col = mix(col, power_flash_color.rgb, v_phase_err_anim.w);
		}

		COLOR.rgb = linear_to_srgb(col);
	}
}