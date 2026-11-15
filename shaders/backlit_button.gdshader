shader_type canvas_item;

// --- GEOMETRY & SHAPE ---
group_uniforms Base_Geometry;
uniform vec2 rect_size = vec2(200.0, 100.0); 
uniform float bevel_width_x : hint_range(1.0, 100.0) = 16.0;
uniform float bevel_smoothness : hint_range(0.0, 50.0) = 6.0;   
uniform float outer_corner_radius : hint_range(0.0, 100.0) = 0.0; 
uniform vec4 independent_corner_radii = vec4(0.0, 0.0, 0.0, 0.0); // TL, TR, BR, BL

group_uniforms Advanced_Geometry_And_Housing;
uniform bool enable_asymmetrical_bevels = false;                  
uniform float bevel_width_y : hint_range(1.0, 100.0) = 16.0;      
uniform float convex_cap_dome : hint_range(0.0, 5.0) = 0.0;       
uniform float recessed_cap_depth : hint_range(0.0, 5.0) = 0.0;    
uniform float bevel_profile_curve : hint_range(0.1, 5.0) = 1.0;   
uniform float housing_occlusion : hint_range(0.0, 5.0) = 0.0;     
uniform float housing_occlusion_distance : hint_range(0.01, 1.0) = 0.3;
uniform float inner_seam_ao : hint_range(0.0, 1.0) = 0.0;         

// --- COLORS & OVERRIDES ---
group_uniforms Global_Color_Settings;
uniform vec4 global_color : source_color = vec4(0.15, 0.16, 0.16, 1.0); 
uniform float unlit_albedo_tint : hint_range(0.0, 1.0) = 0.0;     
uniform float edge_color_blend : hint_range(0.0, 1.0) = 0.2; 
uniform float cap_transparency : hint_range(0.0, 1.0) = 0.5;    
uniform float bevel_opacity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Inactive_Color_Overrides;
uniform bool override_inactive_cap = false;
uniform int inactive_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_cap_gradient : hint_default_white;
uniform bool override_inactive_bevel = false;
uniform int inactive_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_bevel_gradient : hint_default_white;
uniform bool override_inactive_edge = false;
uniform int inactive_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_edge_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_edge_gradient : hint_default_white;

group_uniforms Active_Color_Overrides;
uniform bool override_active_cap = false;
uniform int active_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int active_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_cap_gradient : hint_default_white;
uniform bool override_active_bevel = false;
uniform int active_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int active_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_bevel_gradient : hint_default_white;
uniform bool override_active_edge = false;
uniform int active_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int active_edge_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_edge_gradient : hint_default_white;

// --- MAIN IRIDESCENCE ---
group_uniforms Main_Iridescence;
uniform bool enable_main_iridescence = false;
uniform bool main_irid_exclude_stamp1 = false;
uniform bool main_irid_exclude_stamp2 = false;
uniform int carbon_fiber_masks_iridescence : hint_enum("Off", "Full", "Cap Only", "Bevel Only") = 0;

group_uniforms Main_Iridescence.Cap_Iridescence;
uniform float main_irid_cap_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float main_irid_cap_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float main_irid_cap_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool main_irid_cap_mouse_fade = false;
uniform float main_irid_cap_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool main_irid_cap_use_gradient = false;
uniform sampler2D main_irid_cap_gradient : hint_default_white;

group_uniforms Main_Iridescence.Bevel_Iridescence;
uniform float main_irid_bevel_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float main_irid_bevel_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float main_irid_bevel_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool main_irid_bevel_mouse_fade = false;
uniform float main_irid_bevel_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool main_irid_bevel_use_gradient = false;
uniform sampler2D main_irid_bevel_gradient : hint_default_white;

// --- SHAPE MODIFIERS ---
group_uniforms Rocker_Shape;
uniform float tilt_amount : hint_range(-1.0, 1.0) = 0.0; 
uniform bool tilt_axis_is_x = false;
uniform bool tilt_use_custom_curve = false; 
uniform sampler2D tilt_custom_curve : hint_default_white; 
uniform float bevel_sink_amount : hint_range(0.0, 1.0) = 0.0;
uniform bool bevel_sink_axis_is_x = false;
uniform bool bevel_sink_use_custom_curve = false; 
uniform sampler2D bevel_sink_custom_curve : hint_default_white; 
uniform float face_curvature_amount : hint_range(-2.0, 2.0) = 0.0; 
uniform bool face_curvature_axis_is_x = false; 

group_uniforms Rocker_Split;
uniform bool enable_rocker_split = false;
uniform bool split_on_x_axis = false;
uniform float split_width : hint_range(0.01, 0.5) = 0.08;
uniform float split_smoothness : hint_range(0.001, 0.5) = 0.05;
uniform float split_depth : hint_range(0.0, 3.0) = 1.0;

// --- SURFACE & REFLECTIONS ---
group_uniforms Surface_Appearance;
uniform float smoothness : hint_range(0.0, 1.0) = 0.85;           
uniform float bevel_smoothness_override : hint_range(-1.0, 1.0) = -1.0; 
uniform float specular_intensity : hint_range(0.0, 3.0) = 1.2;     
uniform float fresnel_power : hint_range(1.0, 8.0) = 4.0;          
uniform vec4 fresnel_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); 
uniform float refraction_distortion : hint_range(0.0, 35.0) = 14.0;
uniform float environment_reflectivity : hint_range(0.0, 1.0) = 0.35;

group_uniforms Advanced_Specular_Clearcoat;
uniform vec2 manual_specular_offset = vec2(0.0, 0.0);              
uniform float anisotropic_stretch : hint_range(0.0, 1.0) = 0.0;      
uniform bool enable_dual_lobe_clearcoat = false;                     
uniform float clearcoat_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float clearcoat_shininess : hint_range(10.0, 500.0) = 250.0;
uniform float edge_catching_glint : hint_range(0.0, 5.0) = 0.0;      

// --- MULTIPOINT LIGHTING ---
group_uniforms Lighting_And_Shadows;
uniform vec2 light_direction = vec2(-0.707, -0.707);            
uniform float bevel_highlight : hint_range(0.0, 2.0) = 0.8;
uniform float bevel_shadow : hint_range(0.0, 2.0) = 0.6;
uniform float edge_darkening : hint_range(0.0, 1.0) = 0.0; 
uniform float corner_edge_darkening : hint_range(0.0, 1.0) = 0.3; 

group_uniforms Multipoint_Lighting;
uniform bool enable_multipoint_lighting = false;
uniform vec3 fill_light_dir = vec3(0.8, -0.2, 0.5);
uniform vec4 fill_light_color : source_color = vec4(0.1, 0.2, 0.4, 1.0);
uniform float fill_intensity : hint_range(0.0, 2.0) = 0.5;
uniform vec3 rim_light_dir = vec3(0.0, 1.0, 0.2);
uniform vec4 rim_light_color : source_color = vec4(1.0, 1.0, 0.8, 1.0);
uniform float rim_intensity : hint_range(0.0, 5.0) = 1.0;

// --- TEXTURES & STAMPING ---
group_uniforms Texture_And_Imperfections;
uniform bool use_optional_surface_texture = false;
uniform int surface_texture_stamp_mask : hint_enum("None", "Mask White Areas", "Mask Black Areas") = 0;
uniform sampler2D optional_surface_texture : hint_normal, filter_linear_mipmap; 
uniform vec2 texture_tiling = vec2(1.0, 1.0);
uniform float normal_map_depth : hint_range(0.0, 5.0) = 1.0;      
uniform float texture_influence : hint_range(0.0, 1.0) = 0.35;    
uniform bool use_optional_bevel_texture = false;
uniform sampler2D optional_bevel_texture : hint_normal, filter_linear_mipmap; 
uniform vec2 bevel_texture_tiling = vec2(1.0, 1.0);
uniform float bevel_normal_depth : hint_range(0.0, 5.0) = 1.0;
uniform float bevel_texture_influence : hint_range(0.0, 1.0) = 0.35;
uniform float procedural_grain : hint_range(0.0, 1.0) = 0.15;     
uniform float backlight_texture_reveal : hint_range(0.0, 2.0) = 0.0; 

group_uniforms Texture_And_Imperfections.Carbon_Fiber;
uniform float carbon_fiber_intensity : hint_range(0.0, 1.0) = 0.0;
uniform int carbon_fiber_pattern : hint_enum("Standard Checker", "Diagonal Weave", "Custom Texture") = 0;
uniform sampler2D custom_carbon_texture : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform bool carbon_fiber_split_axis_scale = false;
uniform float carbon_fiber_scale : hint_range(1.0, 100.0) = 20.0;
uniform vec2 carbon_fiber_scale_xy = vec2(20.0, 20.0);
uniform vec2 carbon_fiber_pan_speed = vec2(0.0, 0.0);
uniform int carbon_fiber_stamp_mask : hint_enum("None", "Mask White Areas", "Mask Black Areas") = 0;
uniform float carbon_fiber_hue_shift : hint_range(-180.0, 180.0) = 0.0;
uniform float carbon_fiber_albedo_darkening : hint_range(0.0, 1.0) = 0.0;

// --- SURFACE STAMPING MASTER GROUP ---
group_uniforms Surface_Stamping.Stamp1_Base;
uniform bool enable_stamping = false;
uniform float stamp1_base_opacity : hint_range(0.0, 1.0) = 1.0;
uniform int stamp1_base_mapping_mode : hint_enum("Stretch", "Keep Aspect") = 0;
uniform bool stamp1_base_cap_only = false;
uniform float stamp1_base_surface_wrapping : hint_range(0.0, 1.0) = 0.0;
uniform vec2 stamp1_base_scale = vec2(1.0, 1.0);
uniform vec2 stamp1_base_offset = vec2(0.0, 0.0);
uniform float stamp1_base_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 stamp1_base_uv_panning = vec2(0.0, 0.0);
uniform bool stamp1_base_grid_tiling = false;
uniform vec2 stamp1_base_grid_scale = vec2(3.0, 3.0);
uniform vec2 stamp1_base_grid_offset = vec2(0.0, 0.0);
uniform bool stamp1_base_repeat = false;
uniform float stamp1_base_edge_sharpness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D stamp1_base_MSDF_texture : hint_default_black, filter_linear_mipmap;

group_uniforms Surface_Stamping.Stamp1_Outline;
uniform bool stamp1_outline_enabled = false;
uniform float stamp1_outline_size : hint_range(0.0, 50.0) = 5.0;
uniform float stamp1_outline_depth : hint_range(-5.0, 5.0) = 1.0;
uniform vec4 stamp1_outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_outline_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp1_outline_roughness : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_outline_metallic : hint_range(-1.0, 1.0) = -1.0;
uniform bool stamp1_outline_use_iridescence = false;
uniform bool stamp1_outline_mouse_fade = false;
uniform float stamp1_outline_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp1_outline_mouse_hover = false;

group_uniforms Surface_Stamping.Stamp1_Depth;
uniform float stamp1_depth : hint_range(-1.0, 1.0) = 0.0;
uniform bool stamp1_depth_split_axis = false;
uniform vec2 stamp1_depth_split_xy = vec2(1.0, 1.0);
uniform float stamp1_bevel_width : hint_range(0.0, 0.5) = 0.05;
uniform float stamp1_bevel_curve : hint_range(0.1, 5.0) = 1.0;
uniform bool stamp1_bevel_invert_curve = false;
uniform float stamp1_depth_softness : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_depth_inset_shadow : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_depth_crevice_dirt : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_depth_dirt_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float stamp1_depth_dirt_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp1_depth_dirt_contrast : hint_range(0.1, 5.0) = 1.0;

group_uniforms Surface_Stamping.Stamp1_Appearance;
uniform int stamp1_appear_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp1_appear_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_appear_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_appear_albedo_margin : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp1_appear_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_appear_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_appear_cap_transparency : hint_range(0.0, 1.0) = 0.0;

group_uniforms Surface_Stamping.Stamp1_Iridescence;
uniform float stamp1_appear_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_irid_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float stamp1_appear_irid_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool stamp1_appear_irid_mouse_fade = false;
uniform float stamp1_appear_irid_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp1_appear_irid_use_gradient = false;
uniform sampler2D stamp1_appear_irid_gradient : hint_default_white;

group_uniforms Surface_Stamping.Stamp1_Interactivity;
uniform bool stamp1_interact_active_swap = false;
uniform int stamp1_interact_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp1_interact_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_interact_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_interact_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp1_interact_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_interact_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_interact_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_cap_transparency : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_press_depth_link : hint_range(0.0, 1.0) = 0.0;
uniform bool stamp1_interact_heat_isolate = false;

group_uniforms Surface_Stamping.Stamp2_Base;
uniform bool enable_stamp_2 = false;
uniform float stamp2_base_opacity : hint_range(0.0, 1.0) = 1.0;
uniform int stamp2_base_mapping_mode : hint_enum("Stretch", "Keep Aspect") = 0;
uniform bool stamp2_base_cap_only = false;
uniform float stamp2_base_surface_wrapping : hint_range(0.0, 1.0) = 0.0;
uniform vec2 stamp2_base_scale = vec2(1.0, 1.0);
uniform vec2 stamp2_base_offset = vec2(0.0, 0.0);
uniform float stamp2_base_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 stamp2_base_uv_panning = vec2(0.0, 0.0);
uniform bool stamp2_base_grid_tiling = false;
uniform vec2 stamp2_base_grid_scale = vec2(3.0, 3.0);
uniform vec2 stamp2_base_grid_offset = vec2(0.0, 0.0);
uniform bool stamp2_base_repeat = false;
uniform float stamp2_base_edge_sharpness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D stamp2_base_MSDF_texture : hint_default_black, filter_linear_mipmap;

group_uniforms Surface_Stamping.Stamp2_Outline;
uniform bool stamp2_outline_enabled = false;
uniform float stamp2_outline_size : hint_range(0.0, 50.0) = 5.0;
uniform float stamp2_outline_depth : hint_range(-5.0, 5.0) = 1.0;
uniform vec4 stamp2_outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_outline_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp2_outline_roughness : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_outline_metallic : hint_range(-1.0, 1.0) = -1.0;
uniform bool stamp2_outline_use_iridescence = false;
uniform bool stamp2_outline_mouse_fade = false;
uniform float stamp2_outline_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp2_outline_mouse_hover = false;

group_uniforms Surface_Stamping.Stamp2_Depth;
uniform float stamp2_depth : hint_range(-1.0, 1.0) = 0.0;
uniform bool stamp2_depth_split_axis = false;
uniform vec2 stamp2_depth_split_xy = vec2(1.0, 1.0);
uniform float stamp2_bevel_width : hint_range(0.0, 0.5) = 0.05;
uniform float stamp2_bevel_curve : hint_range(0.1, 5.0) = 1.0;
uniform bool stamp2_bevel_invert_curve = false;
uniform float stamp2_depth_softness : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_depth_inset_shadow : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_depth_crevice_dirt : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_depth_dirt_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float stamp2_depth_dirt_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp2_depth_dirt_contrast : hint_range(0.1, 5.0) = 1.0;

group_uniforms Surface_Stamping.Stamp2_Appearance;
uniform int stamp2_appear_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp2_appear_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_appear_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_appear_albedo_margin : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp2_appear_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_appear_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_appear_cap_transparency : hint_range(0.0, 1.0) = 0.0;

group_uniforms Surface_Stamping.Stamp2_Iridescence;
uniform float stamp2_appear_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_irid_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float stamp2_appear_irid_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool stamp2_appear_irid_mouse_fade = false;
uniform float stamp2_appear_irid_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp2_appear_irid_use_gradient = false;
uniform sampler2D stamp2_appear_irid_gradient : hint_default_white;

group_uniforms Surface_Stamping.Stamp2_Interactivity;
uniform bool stamp2_interact_active_swap = false;
uniform int stamp2_interact_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp2_interact_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_interact_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_interact_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp2_interact_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_interact_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_interact_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_cap_transparency : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_press_depth_link : hint_range(0.0, 1.0) = 0.0;
uniform bool stamp2_interact_heat_isolate = false;

// --- INTERNAL LIGHTING ---
group_uniforms Backlight_State;
uniform bool is_active = false; 
uniform float backlight_intensity : hint_range(0.0, 5.0) = 2.5;
uniform vec4 backlight_color : source_color = vec4(1.0, 0.68, 0.1, 1.0); 
uniform float ignition_stutter_intensity : hint_range(0.0, 1.0) = 0.0;

group_uniforms Voltage_Flicker;
uniform bool enable_voltage_flicker = false;
uniform bool voltage_flicker_smooth = false;
uniform float voltage_flicker_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float voltage_flicker_speed : hint_range(0.1, 60.0) = 20.0;

group_uniforms Internal_Bulbs;
uniform int bulb_layout : hint_enum("Row", "Grid", "Ring") = 0;
uniform int bulb_count : hint_range(1, 10) = 2;
uniform int filament_shape : hint_enum("Sphere", "Square SMD", "Tube", "Ring", "Cross", "Diamond") = 0;
uniform float bulb_size : hint_range(0.01, 0.5) = 0.12;
uniform vec2 filament_stretch = vec2(1.0, 1.0);                      
uniform bool is_led_profile = false;                                 
uniform float bulb_spacing : hint_range(0.0, 1.0) = 0.3;
uniform float bulb_halo_power : hint_range(1.0, 10.0) = 5.0;         
uniform vec4 bulb_off_color : source_color = vec4(0.25, 0.2, 0.1, 0.8);
uniform vec4 bulb_on_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform bool use_blackbody_colors = false;

group_uniforms Internal_Bulbs.Baffle_Grid;
uniform vec2 internal_baffle_grid = vec2(0.0, 0.0);
uniform float baffle_thickness : hint_range(0.01, 1.0) = 0.05;
uniform float baffle_softness : hint_range(0.001, 1.0) = 0.02;
uniform float baffle_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float baffle_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 baffle_grid_offset = vec2(0.0, 0.0);
uniform bool baffle_cap_only = true;

group_uniforms Internal_Bulbs.Secondary_Baffle_Grid;
uniform bool use_secondary_grid = false;
uniform vec2 sec_internal_baffle_grid = vec2(0.0, 0.0);
uniform float sec_baffle_thickness : hint_range(0.01, 1.0) = 0.05;
uniform float sec_baffle_softness : hint_range(0.001, 1.0) = 0.02;
uniform float sec_baffle_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float sec_baffle_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 sec_baffle_grid_offset = vec2(0.0, 0.0);
uniform bool sec_baffle_cap_only = true;

group_uniforms Internal_Bulbs.Advanced_3D;
uniform bool use_3d_spherical_bulbs = false;
uniform float bulb_3d_depth : hint_range(0.1, 3.0) = 1.0;
uniform float bulb_3d_shininess : hint_range(1.0, 128.0) = 32.0;
uniform float bulb_3d_specular_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float bulb_3d_rim_glow : hint_range(0.0, 3.0) = 0.8;
uniform float bulb_3d_transparency : hint_range(0.0, 1.0) = 0.2;
uniform float bulb_3d_core_size : hint_range(0.01, 1.0) = 0.4;
uniform float bulb_3d_core_smoothness : hint_range(0.01, 1.0) = 0.3;
uniform int use_global_light_for_3d_bulb : hint_enum("Off", "Normal", "Inverted X", "Inverted Y", "Inverted X and Y") = 1;
uniform vec2 bulb_3d_light_direction = vec2(0.5, 0.5);

group_uniforms Advanced_Subsurface_Scattering;
uniform float backplate_bounce_light : hint_range(0.0, 5.0) = 0.0;   
uniform float cloudy_refraction_noise : hint_range(0.0, 1.0) = 0.0;  
uniform float corner_pooling_shadow : hint_range(0.0, 1.0) = 0.0;    
uniform bool enable_dual_layer_hue = false;                          
uniform vec4 secondary_subsurface_hue : source_color = vec4(1.0, 0.0, 0.0, 1.0);

group_uniforms Light_Scattering;
uniform int bevel_light_mode : hint_enum("Standard Subsurface", "Milky Translucent", "Crystal Refractive", "Fiber Optic Edge") = 0;
uniform float light_scatter : hint_range(0.1, 10.0) = 2.0;               
uniform float frosted_diffusion : hint_range(0.0, 1.0) = 0.6;            
uniform float side_illumination_boost : hint_range(0.0, 10.0) = 2.5;  
uniform float side_rim_leak : hint_range(0.0, 5.0) = 1.0;             
uniform float side_inner_glow : hint_range(0.0, 5.0) = 1.5;           
uniform float side_glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float side_light_falloff : hint_range(0.1, 5.0) = 1.5;         
uniform float side_angle_sensitivity : hint_range(0.0, 1.0) = 0.65;    
uniform float side_color_shift : hint_range(0.0, 1.0) = 0.85;          
uniform float base_light_retention : hint_range(0.0, 1.0) = 0.15;      

group_uniforms Advanced_Slope_Lighting;
uniform bool enable_advanced_slope_lighting = false;
uniform float slope_light_position : hint_range(0.0, 1.0) = 0.8;
uniform float slope_light_width : hint_range(0.01, 1.0) = 0.15;
uniform float slope_light_smoothness : hint_range(0.001, 1.0) = 0.2;
uniform float slope_light_intensity : hint_range(0.0, 10.0) = 3.0;
uniform float slope_light_corner_fade : hint_range(0.0, 1.0) = 0.5;
uniform vec4 slope_light_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

group_uniforms Interactive_Mouse_Lighting;
uniform bool enable_mouse_light = false; 
uniform vec2 mouse_position = vec2(0.0, 0.0); 
uniform vec4 inactive_mouse_light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inactive_mouse_light_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float inactive_mouse_light_range : hint_range(10.0, 1000.0) = 250.0;
uniform float inactive_mouse_light_height : hint_range(10.0, 500.0) = 50.0;
uniform vec4 active_mouse_light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float active_mouse_light_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float active_mouse_light_range : hint_range(10.0, 1000.0) = 250.0;
uniform float active_mouse_light_height : hint_range(10.0, 500.0) = 50.0;

group_uniforms Experimental_Features;
uniform float heat_distortion_intensity : hint_range(0.0, 1.0) = 0.0;

// --- POST PROCESSING ---
group_uniforms Post_Processing;
uniform float global_brightness : hint_range(-1.0, 1.0) = 0.0;
uniform float global_contrast : hint_range(0.1, 3.0) = 1.0;          
uniform float global_saturation : hint_range(0.0, 3.0) = 1.0;
uniform float global_vibrance : hint_range(-1.0, 2.0) = 0.0;
uniform float global_hue_shift : hint_range(-180.0, 180.0) = 0.0;
uniform float light_bleed_overflow : hint_range(0.0, 1.0) = 0.0;     

// --- FAST GPU HASH & MATH UTILITIES ---
float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash2(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

float fast_pow(float b, float e) {
    if (e == 1.0) return b;
    if (e == 2.0) return b * b;
    if (e == 4.0) { float b2 = b * b; return b2 * b2; }
    if (e == 0.0) return 1.0;
    return pow(b, e);
}

vec3 safe_normalize(vec3 v) {
    float len_sq = dot(v, v);
    return len_sq > 0.000001 ? v * inversesqrt(len_sq) : vec3(0.0, 0.0, 1.0);
}

vec3 apply_hue_shift(vec3 col, float deg) {
    float rad = deg * 0.017453292;
    vec3 k = vec3(0.57735);
    float c = cos(rad);
    return col * c + cross(k, col) * sin(rad) + k * dot(k, col) * (1.0 - c);
}

vec4 apply_blend(vec4 base, vec4 blend, int mode) {
    if (mode == 0) return blend;
    if (mode == 1) return vec4(mix(base.rgb, blend.rgb, blend.a), max(base.a, blend.a));
    if (mode == 2) return vec4(base.rgb * blend.rgb, max(base.a, blend.a));
    if (mode == 3) return min(base + blend, vec4(1.0));
    if (mode == 4) return vec4(base.rgb + blend.rgb - base.rgb * blend.rgb, max(base.a, blend.a));
    return max(base - blend * blend.a, vec4(0.0));
}

vec2 get_grad_coord(vec2 uv, int dir) {
    if (dir == 1) return vec2(uv.y, 0.5);
    if (dir == 2) return vec2((uv.x + uv.y) * 0.5, 0.5);
    if (dir == 3) return vec2(distance(uv, vec2(0.5)) * 1.41421, 0.5);
    return vec2(uv.x, 0.5);
}

float get_corner_radius_mask(vec2 px, vec2 size, float base_r, vec4 custom_r) {
    vec2 half_size = size * 0.5;
    bool is_left = px.x < half_size.x;
    bool is_top = px.y < half_size.y;
    float rx = is_left ? (is_top ? custom_r.x : custom_r.w) : (is_top ? custom_r.y : custom_r.z);
    float final_r = max(base_r, rx);
    if (final_r <= 0.0) return 1.0;
    vec2 d = abs(px - half_size) - (half_size - vec2(final_r));
    return 1.0 - smoothstep(final_r - 1.0, final_r + 1.0, length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0));
}

float get_msdf(sampler2D tex, vec2 uv) {
    vec3 c = texture(tex, uv).rgb;
    return max(min(c.r, c.g), min(max(c.r, c.g), c.b));
}

vec3 eval_iridescence(float dot_val, float scale, float sat, bool use_grad, sampler2D grad_tex) {
    float t = dot_val * scale;
    if (use_grad) {
        return texture(grad_tex, vec2(fract(t), 0.5)).rgb;
    }
    vec3 irid_color = clamp(vec3(sin(t), sin(t + 2.094), sin(t + 4.188)) * 0.5 + 0.5, 0.0, 1.0);
    return mix(vec3(dot(irid_color, vec3(0.333))), irid_color, sat);
}

float eval_baffle_grid(
    vec2 refracted_px, vec2 grid_freq, float thickness, float softness,
    float opacity, float rotation, vec2 offset, bool cap_only, float bevel_factor
) {
    if (grid_freq.x <= 0.0 && grid_freq.y <= 0.0) return 0.0;
    if (cap_only && bevel_factor >= 1.0) return 0.0;
    
    vec2 grid_px = refracted_px;
    if (rotation != 0.0) {
        float rad = rotation * 0.017453292;
        float cr = cos(rad);
        float sr = sin(rad);
        grid_px = vec2(grid_px.x * cr - grid_px.y * sr, grid_px.x * sr + grid_px.y * cr);
    }
    vec2 grid = fract((grid_px * (0.1 * grid_freq)) + offset);
    float b_line_x = grid_freq.x > 0.0 ? (1.0 - smoothstep(thickness - softness, thickness + softness, grid.x)) : 0.0;
    float b_line_y = grid_freq.y > 0.0 ? (1.0 - smoothstep(thickness - softness, thickness + softness, grid.y)) : 0.0;
    float mask = max(b_line_x, b_line_y) * opacity;
    return cap_only ? ((1.0 - bevel_factor) * mask) : mask;
}

void evaluate_stamp(
    vec2 uv, vec2 px, vec2 heat_dist_offset, vec2 r_size, float inv_min_dim,
    float bevel_factor, bool active_state, float tilt_amt, vec2 light_dir,
    bool m_light_enabled, vec2 m_pos, float act_m_h, float inact_m_h, float heat_dist_int,
    float base_opacity, int mapping_mode, bool cap_only, float surface_wrapping,
    vec2 base_scale, vec2 base_offset, float base_rotation, vec2 uv_panning,
    bool grid_tiling, vec2 grid_scale, vec2 grid_offset, bool base_repeat,
    float edge_sharpness, sampler2D msdf_tex,
    bool outline_enabled, float outline_size, float outline_depth, vec4 outline_color,
    float outline_opacity, float outline_roughness, float outline_metallic,
    bool outline_use_irid, bool outline_mouse_fade, float outline_fade_range, bool outline_mouse_hover,
    float s_depth, bool depth_split_axis, vec2 depth_split_xy, float s_bevel_width,
    float s_bevel_curve, bool bevel_invert_curve, float depth_softness, float depth_inset_shadow,
    float depth_crevice_dirt, vec4 dirt_color, float dirt_opacity, float dirt_contrast,
    int appear_blend_mode, float appear_blend, vec4 appear_color, float appear_margin,
    float appear_emissive, float appear_blocker, float appear_roughness, float appear_metallic, float appear_transp,
    float irid_foil, float irid_sat, float irid_scale, bool irid_mouse_fade, float irid_fade_range,
    bool irid_use_grad, sampler2D irid_grad,
    bool interact_active_swap, int interact_blend_mode, float interact_blend, vec4 interact_color,
    float interact_emissive, float interact_blocker, float interact_roughness, float interact_metallic,
    float interact_foil, float interact_transp, float interact_press_depth_link, bool interact_heat_isolate,
    inout vec3 base_normal, inout vec4 stamp_albedo_acc, inout vec4 stamp_dirt_acc,
    inout float stamp_emissive_acc, inout float stamp_blocker_acc, inout float stamp_transparency_acc,
    inout float stamp_shadow_acc, inout float stamp_roughness_val, inout float stamp_roughness_blend,
    inout float stamp_metallic_val, inout float stamp_metallic_blend, inout float global_stamp_mask,
    out float stamp_exclusion
) {
    stamp_exclusion = 0.0;
    
    float cap_mask = cap_only ? (1.0 - bevel_factor) : 1.0;
    if (cap_mask <= 0.0) return;
    if (base_opacity <= 0.0 && (!outline_enabled || outline_size <= 0.0 || outline_opacity <= 0.0)) return;
    
    vec2 panned_uv = (uv_panning != vec2(0.0)) ? fract(uv - TIME * uv_panning) : uv;
    vec2 st_uv = (mapping_mode == 1) ? (((panned_uv - 0.5) * r_size * inv_min_dim) + 0.5) : panned_uv;
    
    if (surface_wrapping > 0.0) {
        st_uv -= base_normal.xy * surface_wrapping * 0.15;
    }
    
    st_uv -= 0.5;
    if (base_rotation != 0.0) {
        float r_rad = base_rotation * 0.017453292;
        float cr = cos(r_rad);
        float sr = sin(r_rad);
        st_uv = vec2(st_uv.x * cr - st_uv.y * sr, st_uv.x * sr + st_uv.y * cr);
    }
    st_uv = (st_uv / max(vec2(0.001), base_scale)) + 0.5 - base_offset;
    
    if (!base_repeat && !grid_tiling) {
        if (st_uv.x < 0.0 || st_uv.x > 1.0 || st_uv.y < 0.0 || st_uv.y > 1.0) return;
    } else if (grid_tiling) {
        st_uv = fract(st_uv * grid_scale + grid_offset);
    } else {
        st_uv = fract(st_uv);
    }

    if (interact_heat_isolate && heat_dist_int > 0.0 && active_state) {
        st_uv += (hash2(st_uv + TIME * 0.1) * 2.0 - 1.0) * heat_dist_int * 0.1;
    }

    float d_center = get_msdf(msdf_tex, st_uv);
    float aa_width = mix(0.1, 0.001, edge_sharpness);
    float s0 = smoothstep(0.5 - aa_width, 0.5 + aa_width, d_center);
    
    global_stamp_mask = max(global_stamp_mask, s0 * cap_mask);

    bool od_sampled = false;
    float od_l = 0.0;
    float od_r = 0.0;
    float od_u = 0.0;
    float od_d = 0.0;

    // --- OUTLINE EVALUATION ---
    if (outline_enabled && outline_size > 0.0 && outline_opacity > 0.0) {
        float out_dist = outline_size * 0.005;
        float o_max = smoothstep(0.5 - out_dist - aa_width, 0.5 - out_dist + aa_width, d_center);
        float o_mask = clamp(o_max - s0, 0.0, 1.0) * cap_mask;
        
        if (o_mask > 0.0) {
            float m_fade = 1.0;
            if (m_light_enabled) {
                if (outline_mouse_hover) {
                    if (m_pos.x < 0.0 || m_pos.x > r_size.x || m_pos.y < 0.0 || m_pos.y > r_size.y) {
                        m_fade = 0.0;
                    }
                }
                if (outline_mouse_fade && m_fade > 0.0) {
                    float m_dist = length(m_pos - (px - heat_dist_offset));
                    m_fade *= smoothstep(outline_fade_range, 0.0, m_dist);
                }
            }
            
            float final_o_alpha = o_mask * outline_opacity * m_fade;
            if (final_o_alpha > 0.0) {
                stamp_exclusion = max(stamp_exclusion, final_o_alpha);
                stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(outline_color.rgb, final_o_alpha), 1);
                
                if (outline_roughness >= 0.0) {
                    stamp_roughness_val = mix(stamp_roughness_val, outline_roughness, final_o_alpha);
                    stamp_roughness_blend = max(stamp_roughness_blend, final_o_alpha);
                }
                if (outline_metallic >= 0.0) {
                    stamp_metallic_val = mix(stamp_metallic_val, outline_metallic, final_o_alpha);
                    stamp_metallic_blend = max(stamp_metallic_blend, final_o_alpha);
                }
                if (outline_depth != 0.0) {
                    const float out_d_off = 0.002;
                    od_l = get_msdf(msdf_tex, st_uv - vec2(out_d_off, 0.0));
                    od_r = get_msdf(msdf_tex, st_uv + vec2(out_d_off, 0.0));
                    od_u = get_msdf(msdf_tex, st_uv - vec2(0.0, out_d_off));
                    od_d = get_msdf(msdf_tex, st_uv + vec2(0.0, out_d_off));
                    od_sampled = true;
                    vec2 out_grad = vec2(od_l - od_r, od_u - od_d) * 20.0 * outline_depth;
                    base_normal = safe_normalize(vec3(base_normal.xy + out_grad * final_o_alpha, base_normal.z));
                }
                if (outline_use_irid) {
                    vec3 irid_view = vec3(0.0, 0.0, 1.0);
                    if (m_light_enabled) {
                        float m_h = active_state ? act_m_h : inact_m_h;
                        irid_view = safe_normalize(vec3((px - heat_dist_offset) - m_pos, m_h));
                    }
                    float stamp_dot = max(0.0, dot(base_normal, irid_view));
                    vec3 irid_color = eval_iridescence(stamp_dot, irid_scale, irid_sat, irid_use_grad, irid_grad);
                    stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, final_o_alpha), 1);
                }
            }
        }
    }

    // --- BODY EVALUATION ---
    float s_mask = clamp(s0 * base_opacity * cap_mask, 0.0, 1.0);
    if (s_mask <= 0.0) return;

    stamp_exclusion = max(stamp_exclusion, s_mask);

    bool is_swap = (interact_active_swap && active_state);
    float cur_blend = is_swap ? interact_blend : appear_blend;
    vec4 cur_color = is_swap ? interact_color : appear_color;
    float cur_emiss = is_swap ? interact_emissive : appear_emissive;
    float cur_block = is_swap ? interact_blocker : appear_blocker;
    float cur_rough = is_swap ? interact_roughness : appear_roughness;
    float cur_metal = is_swap ? interact_metallic : appear_metallic;
    float cur_foil = is_swap ? interact_foil : irid_foil;
    float cur_transp = is_swap ? interact_transp : appear_transp;
    int cur_blend_mode = is_swap ? interact_blend_mode : appear_blend_mode;

    vec2 current_depth_xy = (depth_split_axis ? depth_split_xy : vec2(s_depth)) * base_opacity;
    if (interact_press_depth_link > 0.0) {
        current_depth_xy *= mix(1.0, abs(tilt_amt) * 2.0, interact_press_depth_link);
    }

    float inv_w = 1.0 / max(0.001, s_bevel_width);
    float dx = 0.0;
    float dy = 0.0;

    if (current_depth_xy != vec2(0.0) || depth_inset_shadow > 0.0) {
        float d_off = mix(0.002, 0.025, depth_softness);
        float d_l, d_r, d_u, d_d;
        if (od_sampled && depth_softness == 0.0) {
            d_l = od_l;
            d_r = od_r;
            d_u = od_u;
            d_d = od_d;
        } else {
            d_l = get_msdf(msdf_tex, st_uv - vec2(d_off, 0.0));
            d_r = get_msdf(msdf_tex, st_uv + vec2(d_off, 0.0));
            d_u = get_msdf(msdf_tex, st_uv - vec2(0.0, d_off));
            d_d = get_msdf(msdf_tex, st_uv + vec2(0.0, d_off));
        }

        float val_l = clamp((d_l - 0.5) * inv_w, 0.0, 1.0);
        float val_r = clamp((d_r - 0.5) * inv_w, 0.0, 1.0);
        float val_u = clamp((d_u - 0.5) * inv_w, 0.0, 1.0);
        float val_d = clamp((d_d - 0.5) * inv_w, 0.0, 1.0);

        float h_l, h_r, h_u, h_d;
        if (s_bevel_curve == 1.0) {
            h_l = val_l;
            h_r = val_r;
            h_u = val_u;
            h_d = val_d;
        } else if (bevel_invert_curve) {
            h_l = 1.0 - fast_pow(max(0.0, 1.0 - val_l), s_bevel_curve);
            h_r = 1.0 - fast_pow(max(0.0, 1.0 - val_r), s_bevel_curve);
            h_u = 1.0 - fast_pow(max(0.0, 1.0 - val_u), s_bevel_curve);
            h_d = 1.0 - fast_pow(max(0.0, 1.0 - val_d), s_bevel_curve);
        } else {
            h_l = fast_pow(val_l, s_bevel_curve);
            h_r = fast_pow(val_r, s_bevel_curve);
            h_u = fast_pow(val_u, s_bevel_curve);
            h_d = fast_pow(val_d, s_bevel_curve);
        }

        float norm_scale = 0.03 / d_off;
        dx = (h_l - h_r) * norm_scale;
        dy = (h_u - h_d) * norm_scale;
    }

    vec3 st_norm = vec3(dx, dy, 1.0 / max(0.01, abs(current_depth_xy.x)));
    st_norm.xy *= current_depth_xy;
    if (current_depth_xy.x < 0.0) st_norm.xy *= -1.0;
    base_normal = safe_normalize(base_normal + st_norm * cap_mask);
    
    float color_mask = smoothstep(appear_margin, appear_margin + 0.01, s0);
    stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(cur_color.rgb, cur_color.a * color_mask * cur_blend * s_mask), cur_blend_mode);
    
    if (cur_foil > 0.0) {
        vec3 irid_view = vec3(0.0, 0.0, 1.0);
        float mouse_fade = 1.0;
        if (m_light_enabled) {
            float m_h = active_state ? act_m_h : inact_m_h;
            vec3 mouse_vec = vec3((px - heat_dist_offset) - m_pos, m_h);
            float m_len = length(mouse_vec);
            irid_view = (m_len > 0.0001) ? (mouse_vec * (1.0 / m_len)) : vec3(0.0, 0.0, 1.0);
            if (irid_mouse_fade) mouse_fade = smoothstep(irid_fade_range, 0.0, m_len);
        }
        float stamp_dot = max(0.0, dot(base_normal, irid_view));
        vec3 irid_color = eval_iridescence(stamp_dot, irid_scale, irid_sat, irid_use_grad, irid_grad);
        stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, cur_foil * s_mask * mouse_fade), cur_blend_mode);
    }

    stamp_emissive_acc += cur_emiss * s_mask;
    stamp_blocker_acc += cur_block * s_mask;
    stamp_transparency_acc += cur_transp * s_mask;
    
    if (cur_rough >= 0.0) {
        stamp_roughness_val = mix(stamp_roughness_val, cur_rough, s_mask);
        stamp_roughness_blend = max(stamp_roughness_blend, s_mask);
    }
    if (cur_metal >= 0.0) {
        stamp_metallic_val = mix(stamp_metallic_val, cur_metal, s_mask);
        stamp_metallic_blend = max(stamp_metallic_blend, s_mask);
    }
    
    if (depth_inset_shadow > 0.0) {
        float shadow_val = max(0.0, dot(st_norm.xy, light_dir));
        stamp_shadow_acc += depth_inset_shadow * shadow_val * 5.0 * s_mask;
    }
    
    if (depth_crevice_dirt > 0.0) {
        float val_c = clamp((d_center - 0.5) * inv_w, 0.0, 1.0);
        float h_c = (s_bevel_curve == 1.0) ? val_c : (bevel_invert_curve ? (1.0 - fast_pow(max(0.0, 1.0 - val_c), s_bevel_curve)) : fast_pow(val_c, s_bevel_curve));
        float dirt_mask = fast_pow(clamp(1.0 - h_c, 0.0, 1.0), dirt_contrast) * s_mask * depth_crevice_dirt;
        stamp_dirt_acc = apply_blend(stamp_dirt_acc, vec4(dirt_color.rgb, dirt_color.a * dirt_mask * dirt_opacity), 1);
    }
}

void fragment() {
    vec2 px = UV * rect_size;
    vec2 heat_dist_offset = vec2(0.0);
    
    if (heat_distortion_intensity > 0.0 && is_active) {
        heat_dist_offset = (hash2(UV + TIME * 0.1) * 2.0 - 1.0) * heat_distortion_intensity * 15.0;
        px += heat_dist_offset;
    }

    float alpha_mask = get_corner_radius_mask(px, rect_size, outer_corner_radius, independent_corner_radii);
    if (alpha_mask <= 0.0 && light_bleed_overflow == 0.0) discard;

    vec2 half_rect = rect_size * 0.5;
    float min_dim = min(rect_size.x, rect_size.y);
    float inv_min_dim = 1.0 / max(0.0001, min_dim);
    float min_x = min(px.x, rect_size.x - px.x);
    float min_y = min(px.y, rect_size.y - px.y);
    float dist_to_edge = min(min_x, min_y);
    
    float inv_bx = 1.0 / max(0.001, bevel_width_x);
    float inv_by = enable_asymmetrical_bevels ? (1.0 / max(0.001, bevel_width_y)) : inv_bx;
    float miter_progress_x = min_x * inv_bx;
    float miter_progress_y = min_y * inv_by;
    bool is_x_bevel = miter_progress_x < miter_progress_y;

    vec2 centered_uv = UV * 2.0 - 1.0;
    
    float raw_tilt_axis = tilt_axis_is_x ? centered_uv.x : centered_uv.y;
    if (tilt_use_custom_curve) {
        raw_tilt_axis = texture(tilt_custom_curve, vec2(tilt_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    }
    
    float raw_taper_axis = bevel_sink_axis_is_x ? centered_uv.x : centered_uv.y;
    if (bevel_sink_use_custom_curve) {
        raw_taper_axis = texture(bevel_sink_custom_curve, vec2(bevel_sink_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    }
    
    float tilt_mod = enable_rocker_split ? abs(raw_tilt_axis) : raw_tilt_axis;
    float taper_mod = enable_rocker_split ? abs(raw_taper_axis) : raw_taper_axis;

    float taper_scale = 1.0 - (taper_mod * tilt_amount * bevel_sink_amount);
    float dynamic_bevel_width = bevel_width_x * taper_scale;
    float current_dist = dist_to_edge;

    if (enable_asymmetrical_bevels) {
        dynamic_bevel_width = (is_x_bevel ? bevel_width_x : bevel_width_y) * taper_scale;
        current_dist = is_x_bevel ? min_x : min_y;
    }

    float safe_smoothness = min(bevel_smoothness, dynamic_bevel_width * 0.99);
    float bevel_factor = 1.0 - smoothstep(dynamic_bevel_width - safe_smoothness, dynamic_bevel_width + safe_smoothness, current_dist);

    float raw_slope_progression = current_dist * (1.0 / max(0.001, dynamic_bevel_width));
    float slope_progression = fast_pow(clamp(raw_slope_progression, 0.0, 1.0), bevel_profile_curve);

    vec4 final_cap_color = global_color;
    vec4 final_bevel_color = global_color;
    vec4 final_edge_color = global_color;
    
    if (is_active) {
        if (override_active_cap) final_cap_color = apply_blend(global_color, texture(active_cap_gradient, get_grad_coord(UV, active_cap_grad_dir)), active_cap_blend);
        if (override_active_bevel) final_bevel_color = apply_blend(global_color, texture(active_bevel_gradient, get_grad_coord(UV, active_bevel_grad_dir)), active_bevel_blend);
        if (override_active_edge) final_edge_color = apply_blend(global_color, texture(active_edge_gradient, get_grad_coord(UV, active_edge_grad_dir)), active_edge_blend);
    } else {
        if (override_inactive_cap) final_cap_color = apply_blend(global_color, texture(inactive_cap_gradient, get_grad_coord(UV, inactive_cap_grad_dir)), inactive_cap_blend);
        if (override_inactive_bevel) final_bevel_color = apply_blend(global_color, texture(inactive_bevel_gradient, get_grad_coord(UV, inactive_bevel_grad_dir)), inactive_bevel_blend);
        if (override_inactive_edge) final_edge_color = apply_blend(global_color, texture(inactive_edge_gradient, get_grad_coord(UV, inactive_edge_grad_dir)), inactive_edge_blend);
        
        final_cap_color.rgb = mix(final_cap_color.rgb, final_cap_color.rgb * unlit_albedo_tint, 0.5);
        final_bevel_color.rgb = mix(final_bevel_color.rgb, final_bevel_color.rgb * unlit_albedo_tint, 0.5);
    }

    // --- EARLY CARBON FIBER ALBEDO / HUE ---
    float cf_normalized = 0.0;
    if (carbon_fiber_intensity > 0.0 && alpha_mask > 0.0) {
        vec2 cf_scale = carbon_fiber_split_axis_scale ? carbon_fiber_scale_xy : vec2(carbon_fiber_scale);
        vec2 cf_uv = (px * cf_scale * 0.01) + TIME * carbon_fiber_pan_speed;
        
        if (carbon_fiber_pattern == 0) {
            cf_normalized = (step(0.5, fract(cf_uv.x)) == step(0.5, fract(cf_uv.y))) ? 1.0 : 0.0;
        } else if (carbon_fiber_pattern == 1) {
            cf_normalized = (sin((cf_uv.x + cf_uv.y) * 3.14159) * sin((cf_uv.x - cf_uv.y) * 3.14159)) * 0.5 + 0.5;
        } else {
            cf_normalized = texture(custom_carbon_texture, cf_uv).r;
        }
        
        if (carbon_fiber_albedo_darkening > 0.0 && cf_normalized > 0.0) {
            final_cap_color.rgb *= mix(1.0, 1.0 - carbon_fiber_albedo_darkening, cf_normalized);
        }
        if (carbon_fiber_hue_shift != 0.0 && cf_normalized > 0.0) {
            final_cap_color.rgb = apply_hue_shift(final_cap_color.rgb, carbon_fiber_hue_shift * cf_normalized);
        }
    }

    vec2 primary_dir;
    vec2 bev_uv;
    if (is_x_bevel) {
        primary_dir = px.x < half_rect.x ? vec2(1.0, 0.0) : vec2(-1.0, 0.0);
        bev_uv = vec2(slope_progression, px.y * inv_min_dim);
    } else {
        primary_dir = px.y < half_rect.y ? vec2(0.0, 1.0) : vec2(0.0, -1.0);
        bev_uv = vec2(px.x * inv_min_dim, slope_progression);
    }
    
    vec2 diag_dir = vec2(px.x < half_rect.x ? 0.707106 : -0.707106, px.y < half_rect.y ? 0.707106 : -0.707106);
    float actual_corner_dist = enable_asymmetrical_bevels ? abs(miter_progress_x - miter_progress_y) * dynamic_bevel_width : abs(min_x - min_y);
    float miter_blend = 1.0 - smoothstep(0.0, max(1.0, safe_smoothness), actual_corner_dist);
    vec2 bevel_dir = normalize(mix(primary_dir, diag_dir, miter_blend));

    float slope_strength = bevel_factor * 0.85; 
    vec3 base_normal = vec3(bevel_dir * slope_strength, 1.0 - slope_strength * 0.5);
    
    if (convex_cap_dome > 0.0 && bevel_factor >= 1.0) {
        float dome_dist = length(centered_uv);
        float dome_factor = dome_dist * convex_cap_dome * 0.5;
        base_normal.xy += centered_uv * dome_factor;
        base_normal.z -= dome_factor;
    }

    if (recessed_cap_depth > 0.0 && slope_progression > 0.8) {
        float wall_steepness = smoothstep(0.8, 1.0, slope_progression);
        base_normal.xy -= bevel_dir * wall_steepness * recessed_cap_depth;
        base_normal.z += wall_steepness * recessed_cap_depth * 0.5;
    }

    if (tilt_amount != 0.0) {
        float tilt_delta = tilt_mod * tilt_amount;
        if (tilt_axis_is_x) base_normal.x += tilt_delta;
        else base_normal.y += tilt_delta;
        base_normal.z -= abs(tilt_delta) * 0.5;
    }
    
    float seam_darken = 1.0;
    if (enable_rocker_split) {
        float raw_split_axis = split_on_x_axis ? centered_uv.x : centered_uv.y;
        float s_dist = abs(raw_split_axis);
        float cap_mask = 1.0 - bevel_factor; 
        
        if (cap_mask > 0.0) {
            float s_prof = smoothstep(split_width, max(0.001, split_width - split_smoothness), s_dist) * cap_mask;
            if (s_prof > 0.0) {
                base_normal.z -= s_prof * split_depth;
                float s_slope = sign(raw_split_axis) * sin(s_prof * 3.14159) * split_depth * 0.5;
                if (split_on_x_axis) base_normal.x += s_slope;
                else base_normal.y += s_slope;
                seam_darken = 1.0 - (s_prof * clamp(split_depth, 0.0, 1.0) * 0.8);
            }
        }
    }

    if (face_curvature_amount != 0.0) {
        float raw_curve_axis = face_curvature_axis_is_x ? centered_uv.x : centered_uv.y;
        float sin_curve = sin(raw_curve_axis * 1.57079);
        float cap_w = 1.0 - bevel_factor;
        float curve_val = sin_curve * face_curvature_amount * cap_w;
        if (face_curvature_axis_is_x) base_normal.x += curve_val;
        else base_normal.y += curve_val;
        base_normal.z -= abs(sin_curve) * abs(face_curvature_amount) * 0.3 * cap_w;
    }

    // --- ACCUMULATOR VARIABLES FOR DUAL STAMPING ---
    vec4 stamp_albedo_acc = vec4(0.0);
    vec4 stamp_dirt_acc = vec4(0.0);
    float stamp_emissive_acc = 0.0;
    float stamp_blocker_acc = 0.0;
    float stamp_transparency_acc = 0.0;
    float stamp_shadow_acc = 0.0;
    float stamp_roughness_val = 0.0;
    float stamp_roughness_blend = 0.0;
    float stamp_metallic_val = 0.0;
    float stamp_metallic_blend = 0.0;
    float global_stamp_mask = 0.0;
    float stamp1_exclusion = 0.0;
    float stamp2_exclusion = 0.0;

    // --- PRIMARY STAMP ---
    if (enable_stamping) {
        evaluate_stamp(
            UV, px, heat_dist_offset, rect_size, inv_min_dim,
            bevel_factor, is_active, tilt_amount, light_direction,
            enable_mouse_light, mouse_position, active_mouse_light_height, inactive_mouse_light_height, heat_distortion_intensity,
            stamp1_base_opacity, stamp1_base_mapping_mode, stamp1_base_cap_only, stamp1_base_surface_wrapping,
            stamp1_base_scale, stamp1_base_offset, stamp1_base_rotation, stamp1_base_uv_panning,
            stamp1_base_grid_tiling, stamp1_base_grid_scale, stamp1_base_grid_offset, stamp1_base_repeat,
            stamp1_base_edge_sharpness, stamp1_base_MSDF_texture,
            stamp1_outline_enabled, stamp1_outline_size, stamp1_outline_depth, stamp1_outline_color,
            stamp1_outline_opacity, stamp1_outline_roughness, stamp1_outline_metallic,
            stamp1_outline_use_iridescence, stamp1_outline_mouse_fade, stamp1_outline_fade_range, stamp1_outline_mouse_hover,
            stamp1_depth, stamp1_depth_split_axis, stamp1_depth_split_xy, stamp1_bevel_width,
            stamp1_bevel_curve, stamp1_bevel_invert_curve, stamp1_depth_softness, stamp1_depth_inset_shadow,
            stamp1_depth_crevice_dirt, stamp1_depth_dirt_color, stamp1_depth_dirt_opacity, stamp1_depth_dirt_contrast,
            stamp1_appear_albedo_blend_mode, stamp1_appear_albedo_blend, stamp1_appear_albedo_color, stamp1_appear_albedo_margin,
            stamp1_appear_emissive_intensity, stamp1_appear_light_blocker, stamp1_appear_roughness_override, stamp1_appear_metallic_override, stamp1_appear_cap_transparency,
            stamp1_appear_iridescent_foil, stamp1_appear_irid_saturation, stamp1_appear_irid_scale, stamp1_appear_irid_mouse_fade, stamp1_appear_irid_fade_range,
            stamp1_appear_irid_use_gradient, stamp1_appear_irid_gradient,
            stamp1_interact_active_swap, stamp1_interact_albedo_blend_mode, stamp1_interact_albedo_blend, stamp1_interact_albedo_color,
            stamp1_interact_emissive_intensity, stamp1_interact_light_blocker, stamp1_interact_roughness_override, stamp1_interact_metallic_override,
            stamp1_interact_iridescent_foil, stamp1_interact_cap_transparency, stamp1_interact_press_depth_link, stamp1_interact_heat_isolate,
            base_normal, stamp_albedo_acc, stamp_dirt_acc,
            stamp_emissive_acc, stamp_blocker_acc, stamp_transparency_acc,
            stamp_shadow_acc, stamp_roughness_val, stamp_roughness_blend,
            stamp_metallic_val, stamp_metallic_blend, global_stamp_mask,
            stamp1_exclusion
        );
    }

    // --- SECONDARY STAMP ---
    if (enable_stamp_2) {
        evaluate_stamp(
            UV, px, heat_dist_offset, rect_size, inv_min_dim,
            bevel_factor, is_active, tilt_amount, light_direction,
            enable_mouse_light, mouse_position, active_mouse_light_height, inactive_mouse_light_height, heat_distortion_intensity,
            stamp2_base_opacity, stamp2_base_mapping_mode, stamp2_base_cap_only, stamp2_base_surface_wrapping,
            stamp2_base_scale, stamp2_base_offset, stamp2_base_rotation, stamp2_base_uv_panning,
            stamp2_base_grid_tiling, stamp2_base_grid_scale, stamp2_base_grid_offset, stamp2_base_repeat,
            stamp2_base_edge_sharpness, stamp2_base_MSDF_texture,
            stamp2_outline_enabled, stamp2_outline_size, stamp2_outline_depth, stamp2_outline_color,
            stamp2_outline_opacity, stamp2_outline_roughness, stamp2_outline_metallic,
            stamp2_outline_use_iridescence, stamp2_outline_mouse_fade, stamp2_outline_fade_range, stamp2_outline_mouse_hover,
            stamp2_depth, stamp2_depth_split_axis, stamp2_depth_split_xy, stamp2_bevel_width,
            stamp2_bevel_curve, stamp2_bevel_invert_curve, stamp2_depth_softness, stamp2_depth_inset_shadow,
            stamp2_depth_crevice_dirt, stamp2_depth_dirt_color, stamp2_depth_dirt_opacity, stamp2_depth_dirt_contrast,
            stamp2_appear_albedo_blend_mode, stamp2_appear_albedo_blend, stamp2_appear_albedo_color, stamp2_appear_albedo_margin,
            stamp2_appear_emissive_intensity, stamp2_appear_light_blocker, stamp2_appear_roughness_override, stamp2_appear_metallic_override, stamp2_appear_cap_transparency,
            stamp2_appear_iridescent_foil, stamp2_appear_irid_saturation, stamp2_appear_irid_scale, stamp2_appear_irid_mouse_fade, stamp2_appear_irid_fade_range,
            stamp2_appear_irid_use_gradient, stamp2_appear_irid_gradient,
            stamp2_interact_active_swap, stamp2_interact_albedo_blend_mode, stamp2_interact_albedo_blend, stamp2_interact_albedo_color,
            stamp2_interact_emissive_intensity, stamp2_interact_light_blocker, stamp2_interact_roughness_override, stamp2_interact_metallic_override,
            stamp2_interact_iridescent_foil, stamp2_interact_cap_transparency, stamp2_interact_press_depth_link, stamp2_interact_heat_isolate,
            base_normal, stamp_albedo_acc, stamp_dirt_acc,
            stamp_emissive_acc, stamp_blocker_acc, stamp_transparency_acc,
            stamp_shadow_acc, stamp_roughness_val, stamp_roughness_blend,
            stamp_metallic_val, stamp_metallic_blend, global_stamp_mask,
            stamp2_exclusion
        );
    }

    vec3 normal = base_normal;
    float bev_tex_lum = 1.0;

    if (alpha_mask > 0.0) {
        vec3 cap_tex_normal = vec3(0.0, 0.0, 1.0);
        if (use_optional_surface_texture && bevel_factor < 1.0) {
            float tex_stamp_mult = 1.0;
            if (surface_texture_stamp_mask == 1) tex_stamp_mult = clamp(1.0 - global_stamp_mask, 0.0, 1.0);
            else if (surface_texture_stamp_mask == 2) tex_stamp_mult = clamp(global_stamp_mask, 0.0, 1.0);
            
            cap_tex_normal = texture(optional_surface_texture, UV * texture_tiling).rgb * 2.0 - 1.0;
            cap_tex_normal.xy *= normal_map_depth * tex_stamp_mult; 
            cap_tex_normal = safe_normalize(cap_tex_normal);
        }
        
        vec3 bev_tex_normal = vec3(0.0, 0.0, 1.0);
        if (use_optional_bevel_texture && bevel_factor > 0.0) {
            vec4 bev_tex_sample = texture(optional_bevel_texture, bev_uv * bevel_texture_tiling);
            bev_tex_normal = bev_tex_sample.rgb * 2.0 - 1.0;
            bev_tex_normal.xy *= bevel_normal_depth;
            bev_tex_normal = safe_normalize(bev_tex_normal);
            bev_tex_lum = mix(1.0, dot(bev_tex_sample.rgb, vec3(0.299, 0.587, 0.114)) * 1.5, bevel_texture_influence);
        }

        vec3 active_tex_normal = mix(cap_tex_normal, bev_tex_normal, bevel_factor);
        float active_influence = mix(texture_influence, bevel_texture_influence, bevel_factor);
        vec3 detail_normal = mix(vec3(0.0, 0.0, 1.0), active_tex_normal, active_influence);
        
        float grain_weight = procedural_grain * (1.0 - smoothness);
        if (grain_weight > 0.0) {
            vec2 grn2 = hash2(floor(px * 1.5)) * 2.0 - 1.0;
            vec3 grain_normal = normalize(vec3(grn2, 50.0));
            detail_normal = mix(detail_normal, grain_normal, grain_weight);
        }
        
        if (carbon_fiber_intensity > 0.0 && bevel_factor < 1.0) {
            float cf_multiplier = 1.0;
            if (carbon_fiber_stamp_mask == 1) cf_multiplier = clamp(1.0 - global_stamp_mask, 0.0, 1.0);
            else if (carbon_fiber_stamp_mask == 2) cf_multiplier = clamp(global_stamp_mask, 0.0, 1.0);
            
            detail_normal.xy += (cf_normalized * 2.0 - 1.0) * carbon_fiber_intensity * (1.0 - bevel_factor) * cf_multiplier;
        }

        normal = safe_normalize(normal + detail_normal * 0.15);

        if (stamp_dirt_acc.a > 0.0) {
            final_cap_color.rgb = mix(final_cap_color.rgb, stamp_dirt_acc.rgb, stamp_dirt_acc.a);
            final_bevel_color.rgb = mix(final_bevel_color.rgb, stamp_dirt_acc.rgb, stamp_dirt_acc.a);
        }
        if (stamp_albedo_acc.a > 0.0) {
            final_cap_color.rgb = mix(final_cap_color.rgb, stamp_albedo_acc.rgb, stamp_albedo_acc.a);
            final_bevel_color.rgb = mix(final_bevel_color.rgb, stamp_albedo_acc.rgb, stamp_albedo_acc.a);
        }
    }

    vec4 cap_layer = final_cap_color;
    cap_layer.a *= clamp(1.0 - (cap_transparency + stamp_transparency_acc), 0.0, 1.0);

    float total_cap_glow = backplate_bounce_light * 0.1; 
    float total_side_glow = backplate_bounce_light * 0.1;
    float bulb_mask = 0.0;
    vec4 bulb_vis = vec4(0.0);
    float active_mult = 0.0;

    bool need_bulb_glow = (is_active && backlight_intensity > 0.0);
    bool need_bulb_vis = (cap_layer.a < 1.0 && bevel_factor < 1.0 && alpha_mask > 0.0);

    if (need_bulb_glow || need_bulb_vis) {
        vec2 refract_offset = normal.xy * bevel_factor * refraction_distortion;
        if (cloudy_refraction_noise > 0.0) {
            refract_offset += (hash2(px) * 2.0 - 1.0) * cloudy_refraction_noise * 10.0;
        }
        vec2 refracted_px = px - refract_offset;

        float flicker_mod = 1.0;
        if (enable_voltage_flicker && is_active) {
            float noise_flicker;
            if (voltage_flicker_smooth) {
                float t_flk = TIME * voltage_flicker_speed;
                noise_flicker = (sin(t_flk) + sin(t_flk * 0.73) + sin(t_flk * 1.37)) * 0.166 + 0.5;
            } else {
                noise_flicker = hash(vec2(floor(TIME * voltage_flicker_speed), 0.0));
            }
            flicker_mod -= voltage_flicker_intensity * noise_flicker;
        }
        
        if (ignition_stutter_intensity > 0.0 && is_active) {
            float startup_noise = smoothstep(0.2, 0.8, hash(vec2(TIME * 15.0, 1.0)));
            flicker_mod *= mix(1.0, startup_noise, ignition_stutter_intensity);
        }
        
        active_mult = (is_active ? backlight_intensity : 0.0) * flicker_mod;

        vec4 base_b_col = is_active ? bulb_on_color : bulb_off_color;
        if (use_blackbody_colors && is_active) {
            base_b_col.rgb = mix(vec3(1.0, 0.1, 0.0), bulb_on_color.rgb, clamp(active_mult, 0.0, 1.0));
        }
        
        vec4 core_b_col = base_b_col;
        core_b_col.rgb += vec3(is_active ? 3.0 : 0.4);
        core_b_col.rgb *= flicker_mod;
        base_b_col.rgb *= flicker_mod;

        vec2 resolved_3d_light_dir = bulb_3d_light_direction;
        if (use_global_light_for_3d_bulb == 1) resolved_3d_light_dir = light_direction;
        else if (use_global_light_for_3d_bulb == 2) resolved_3d_light_dir = vec2(-light_direction.x, light_direction.y); 
        else if (use_global_light_for_3d_bulb == 3) resolved_3d_light_dir = vec2(light_direction.x, -light_direction.y); 
        else if (use_global_light_for_3d_bulb == 4) resolved_3d_light_dir = -light_direction; 
        vec3 sphere_light_dir = safe_normalize(vec3(-resolved_3d_light_dir, 0.65));
        vec3 sphere_half_vec = safe_normalize(sphere_light_dir + vec3(0.0, 0.0, 1.0));

        int internal_bulb_max = clamp(bulb_count, 1, 10);
        float glass_opacity = clamp(1.0 - bulb_3d_transparency, 0.0, 1.0);
        float active_spec_mult = is_active ? 2.5 : 0.3;
        float active_rim_mult = is_active ? 2.0 : 0.3;
        float bulb_radius_px = bulb_size * min_dim;
        float inv_bulb_radius_px = 1.0 / max(0.0001, bulb_radius_px);
        float inv_core_radius = 1.0 / max(0.0001, bulb_radius_px * bulb_3d_core_size);
        float inv_bulb_3d_depth = 1.0 / max(0.0001, bulb_3d_depth);
        float core_edge_softness = max(0.001, bulb_3d_core_smoothness);
        
        float scatter_power = light_scatter * bulb_halo_power;
        float exp2_scatter = scatter_power * 1.442695;
        float led_halo_scatter = scatter_power * 5.0;
        float led_side_scatter = light_scatter * 5.0;
        float norm_side_scatter = light_scatter * 1.5;
        vec2 inv_filament_stretch = 1.0 / max(vec2(0.001), filament_stretch);

        vec2 bulb_start_pos = vec2(0.0);
        float fcols = 1.0;
        float row_step_x = bulb_spacing * rect_size.x;
        float bulb_spacing_px = bulb_spacing * min_dim;
        float b_count = float(internal_bulb_max);
        vec2 ring_dir = vec2(1.0, 0.0);
        float ring_cos = 1.0;
        float ring_sin = 0.0;

        if (bulb_layout == 0) {
            bulb_start_pos.x = (rect_size.x - (b_count - 1.0) * row_step_x) * 0.5;
            bulb_start_pos.y = half_rect.y;
        } else if (bulb_layout == 1) {
            fcols = ceil(sqrt(b_count));
            float frows = ceil(b_count / fcols);
            bulb_start_pos = (rect_size - vec2(fcols - 1.0, frows - 1.0) * bulb_spacing_px) * 0.5;
        } else {
            float angle_step = 6.283185 / b_count;
            ring_cos = cos(angle_step);
            ring_sin = sin(angle_step);
            bulb_start_pos = half_rect;
        }
        
        bool render_3d_sphere = use_3d_spherical_bulbs && filament_shape == 0;
        float flat_core_boost = is_active ? 1.5 : 0.1;
        
        for (int i = 0; i < internal_bulb_max; i++) {
            vec2 bulb_px;
            if (bulb_layout == 0) {
                bulb_px = vec2(bulb_start_pos.x + float(i) * row_step_x, bulb_start_pos.y);
            } else if (bulb_layout == 1) {
                float fi = float(i);
                bulb_px = bulb_start_pos + vec2(mod(fi, fcols), floor(fi / fcols)) * bulb_spacing_px;
            } else {
                bulb_px = bulb_start_pos + ring_dir * bulb_spacing_px;
                ring_dir = vec2(ring_dir.x * ring_cos - ring_dir.y * ring_sin, ring_dir.x * ring_sin + ring_dir.y * ring_cos);
            }
            
            vec2 bulb_diff = (refracted_px - bulb_px) * inv_filament_stretch;
            float d_bulb_px;
            
            if (filament_shape == 0) {
                d_bulb_px = length(bulb_diff);
            } else if (filament_shape == 1) { 
                d_bulb_px = max(abs(bulb_diff.x), abs(bulb_diff.y));
            } else if (filament_shape == 2) { 
                d_bulb_px = length(bulb_diff - vec2(clamp(bulb_diff.x, -bulb_radius_px, bulb_radius_px), 0.0));
            } else if (filament_shape == 3) {
                d_bulb_px = abs(length(bulb_diff) - bulb_radius_px * 0.5);
            } else if (filament_shape == 4) {
                float hx = clamp(bulb_diff.x, -bulb_radius_px, bulb_radius_px);
                float hy = clamp(bulb_diff.y, -bulb_radius_px, bulb_radius_px);
                d_bulb_px = min(length(bulb_diff - vec2(hx, 0.0)), length(bulb_diff - vec2(0.0, hy)));
            } else {
                d_bulb_px = (abs(bulb_diff.x) + abs(bulb_diff.y)) * 0.707106;
            }
            
            float d_norm = d_bulb_px * inv_min_dim; 

            if (need_bulb_glow) {
                if (is_led_profile) {
                    total_cap_glow += 1.0 / (1.0 + d_norm * led_halo_scatter);
                } else {
                    total_cap_glow += exp2(-d_norm * exp2_scatter);
                }
                
                vec2 dir_to_bulb = (d_bulb_px > 0.0) ? (-bulb_diff * (1.0 / d_bulb_px)) : vec2(0.0);
                float internal_angle = max(0.0, dot(-bevel_dir, dir_to_bulb));
                
                float side_base_falloff = is_led_profile ? (1.0 / (1.0 + d_norm * led_side_scatter)) : (1.0 / (1.0 + d_norm * norm_side_scatter));
                total_side_glow += side_base_falloff * mix(0.4, 1.0, internal_angle * side_angle_sensitivity);
            }

            if (need_bulb_vis) {
                if (render_3d_sphere) {
                    if (d_bulb_px <= bulb_radius_px) {
                        float core_mask = 1.0 - smoothstep(1.0 - core_edge_softness, 1.0, d_bulb_px * inv_core_radius);
                        float sphere_dist = clamp((d_bulb_px * inv_bulb_radius_px) * inv_bulb_3d_depth, 0.0, 1.0);
                        float z = sqrt(max(0.0, 1.0 - sphere_dist * sphere_dist));
                        
                        vec3 sphere_n = normalize(vec3(bulb_diff * inv_bulb_radius_px, z));
                        float s_dot = max(0.0, dot(sphere_n, sphere_half_vec));
                        float spec_h = (s_dot > 0.0) ? pow(s_dot, bulb_3d_shininess) : 0.0;
                        
                        float rim_z = 1.0 - z;
                        vec3 glass_color = base_b_col.rgb * max(0.3, dot(sphere_n, sphere_light_dir)) + vec3(spec_h * bulb_3d_specular_intensity * active_spec_mult);
                        glass_color += backlight_color.rgb * (rim_z * rim_z) * bulb_3d_rim_glow * active_rim_mult;
                        
                        float a_mask = smoothstep(1.0, 0.88, sphere_dist);
                        bulb_vis = mix(bulb_vis, vec4(mix(core_b_col.rgb * core_mask, glass_color, glass_opacity), a_mask), a_mask);
                        bulb_mask = max(bulb_mask, a_mask);
                    }
                } else if (d_norm < bulb_size) {
                    float b_edge = smoothstep(bulb_size, bulb_size - 0.015, d_norm);
                    vec4 flat_col = base_b_col + vec4(smoothstep(bulb_size * 0.4, 0.0, d_norm) * flat_core_boost);
                    bulb_vis = mix(bulb_vis, flat_col, b_edge);
                    bulb_mask = max(bulb_mask, b_edge);
                }
            }
        }
        
        // --- ADVANCED BAFFLE GRID COMBINATION ---
        float b_mask_main = eval_baffle_grid(
            refracted_px, internal_baffle_grid, baffle_thickness, baffle_softness,
            baffle_opacity, baffle_rotation, baffle_grid_offset, baffle_cap_only, bevel_factor
        );
        
        float b_mask_sec = 0.0;
        if (use_secondary_grid) {
            b_mask_sec = eval_baffle_grid(
                refracted_px, sec_internal_baffle_grid, sec_baffle_thickness, sec_baffle_softness,
                sec_baffle_opacity, sec_baffle_rotation, sec_baffle_grid_offset, sec_baffle_cap_only, bevel_factor
            );
        }
        
        float final_b_mask = b_mask_main + b_mask_sec * (1.0 - b_mask_main);
        if (final_b_mask > 0.0) {
            float inv_b = 1.0 - final_b_mask;
            bulb_mask *= inv_b;
            bulb_vis *= inv_b;
            total_cap_glow *= mix(1.0, 0.2, final_b_mask);
            total_side_glow *= mix(1.0, 0.5, final_b_mask);
        }

        float stamp_light_pass = clamp(1.0 - stamp_blocker_acc, 0.0, 1.0);
        total_cap_glow *= stamp_light_pass;
        total_side_glow *= stamp_light_pass;
        bulb_vis *= stamp_light_pass;
        bulb_mask *= stamp_light_pass;
    }

    vec3 effective_backlight_color = enable_dual_layer_hue ? mix(secondary_subsurface_hue.rgb, backlight_color.rgb, clamp(total_side_glow, 0.0, 1.0)) : backlight_color.rgb;
    vec4 final_color;

    if (alpha_mask <= 0.0) {
        float overflow_falloff = exp2(-distance(px, clamp(px, vec2(0.0), rect_size)) * 0.1442695);
        final_color = vec4(effective_backlight_color * total_side_glow * active_mult * light_bleed_overflow * overflow_falloff, overflow_falloff * 0.5 * light_bleed_overflow);
    } else {
        float active_smoothness = mix(smoothness, bevel_smoothness_override, bevel_factor * step(0.0, bevel_smoothness_override));
        active_smoothness = mix(active_smoothness, stamp_roughness_val, stamp_roughness_blend);

        vec3 light_3d = safe_normalize(vec3(-light_direction, 0.65)); 
        float diff_shade = max(0.0, dot(normal, light_3d));
        vec3 ambient_diffuse = vec3(clamp(1.0 + diff_shade * (bevel_highlight - bevel_shadow), 0.15, 2.0));
        ambient_diffuse *= 1.0 - clamp(stamp_shadow_acc, 0.0, 1.0);
        
        float one_minus_nz = max(0.0, 1.0 - normal.z);
        if (enable_multipoint_lighting) {
            vec3 norm_fill = safe_normalize(fill_light_dir);
            vec3 norm_rim = safe_normalize(rim_light_dir);
            ambient_diffuse += max(0.0, dot(normal, norm_fill)) * fill_light_color.rgb * fill_intensity;
            float rim_p2 = one_minus_nz * one_minus_nz;
            ambient_diffuse += (rim_p2 * rim_p2) * max(0.0, dot(normal, norm_rim)) * rim_light_color.rgb * rim_intensity;
        }

        vec3 spec_half_vector = safe_normalize(light_3d + vec3(manual_specular_offset, 1.0));
        if (anisotropic_stretch > 0.0) {
            spec_half_vector.x *= 1.0 + (anisotropic_stretch * (1.0 - abs(normal.x)));
            spec_half_vector.y *= 1.0 + (anisotropic_stretch * (1.0 - abs(normal.y)));
            spec_half_vector = safe_normalize(spec_half_vector);
        }
        
        float spec_factor = max(0.0, dot(normal, spec_half_vector));
        float shininess = mix(3.0, 150.0, active_smoothness); 
        float current_metallic = stamp_metallic_blend * stamp_metallic_val;
        float glint_mult = 1.0 + (miter_blend * edge_catching_glint * bevel_factor);
        
        float spec = 0.0;
        if (spec_factor > 0.0) {
            spec = pow(spec_factor, shininess) * (specular_intensity + current_metallic * 2.0) * glint_mult;
            if (enable_dual_lobe_clearcoat) {
                spec += pow(spec_factor, clearcoat_shininess) * clearcoat_intensity * glint_mult;
            }
        }

        float fresnel = fast_pow(one_minus_nz, fresnel_power);

        float edge_glow_boost = smoothstep(0.0, 2.0, raw_slope_progression);
        float cap_glow = (total_cap_glow * (1.0 - frosted_diffusion) + edge_glow_boost * frosted_diffusion) * active_mult * seam_darken;
        if (backlight_texture_reveal > 0.0) {
            cap_glow *= mix(1.0, clamp(normal.z, 0.0, 1.0), backlight_texture_reveal);
        }

        vec4 cap_final = mix(cap_layer, bulb_vis, bulb_mask * (1.0 - cap_layer.a)) + vec4(effective_backlight_color * cap_glow, cap_glow);
        cap_final.rgb += stamp_albedo_acc.rgb * stamp_emissive_acc * max(active_mult, 0.1);

        vec3 lit_side_color = vec3(0.0);
        if (bevel_factor > 0.0) {
            vec3 base_bevel_rgb = mix(final_bevel_color.rgb, final_edge_color.rgb, smoothstep(edge_color_blend, 0.0, slope_progression));
            base_bevel_rgb *= bev_tex_lum;

            float corner_factor = miter_blend * bevel_factor;
            float housing_darkening = fast_pow(smoothstep(0.0, housing_occlusion_distance, slope_progression), housing_occlusion);
            float pooling_shadow = mix(1.0, 1.0 - corner_factor, corner_pooling_shadow);
            
            lit_side_color = base_bevel_rgb * ambient_diffuse * mix(1.0, 1.0 - edge_darkening, 1.0 - bevel_factor) * mix(1.0, 1.0 - corner_edge_darkening, corner_factor);
            lit_side_color *= housing_darkening * pooling_shadow;
            
            if (inner_seam_ao > 0.0) {
                lit_side_color *= mix(1.0, smoothstep(1.0, 0.85, slope_progression), inner_seam_ao);
            }

            if (active_mult > 0.0 && (side_illumination_boost > 0.0 || enable_advanced_slope_lighting)) {
                float side_bleed = 0.0;
                float base_side_energy = total_side_glow * active_mult;

                if (side_illumination_boost > 0.0) {
                    float falloff_curve = 0.0;
                    if (bevel_light_mode == 0) {
                        falloff_curve = fast_pow(slope_progression, side_light_falloff);
                        side_bleed = base_side_energy * side_glow_intensity * mix(base_light_retention, 1.0, falloff_curve);
                        side_bleed += (side_inner_glow * (1.0 - slope_progression) + side_rim_leak * slope_progression) * base_side_energy;
                    } else if (bevel_light_mode == 1) {
                        falloff_curve = fast_pow(slope_progression, side_light_falloff * 0.3);
                        side_bleed = base_side_energy * side_glow_intensity * 1.2 * mix(max(0.4, base_light_retention), 1.0, falloff_curve);
                    } else if (bevel_light_mode == 2) {
                        falloff_curve = fast_pow(slope_progression, side_light_falloff * 0.8);
                        float sg = total_side_glow + 0.01;
                        side_bleed = (sg * sg) * 1.5 * active_mult * side_glow_intensity * mix(base_light_retention * 0.5, 1.0, falloff_curve);
                    } else if (bevel_light_mode == 3) {
                        falloff_curve = fast_pow(slope_progression, side_light_falloff * 2.0);
                        side_bleed = base_side_energy * side_glow_intensity * mix(base_light_retention * 0.2, 1.0, falloff_curve);
                        side_bleed += (1.0 - slope_progression) * side_rim_leak * 2.0 * base_side_energy;
                    }
                    side_bleed *= side_illumination_boost * bevel_factor;
                }

                if (enable_advanced_slope_lighting) {
                    float half_band = slope_light_width * 0.5;
                    float band_mask = 1.0 - smoothstep(max(0.0, half_band - slope_light_smoothness), half_band + slope_light_smoothness, abs(slope_progression - slope_light_position));
                    side_bleed += band_mask * slope_light_intensity * base_side_energy * mix(1.0, 1.0 - miter_blend, slope_light_corner_fade) * bevel_factor;
                }
                
                vec3 final_glow_color = effective_backlight_color * slope_light_tint.rgb;
                lit_side_color = mix(lit_side_color, final_glow_color, clamp(side_bleed * side_color_shift, 0.0, 1.0)) + (final_glow_color * side_bleed);
            }
        }

        // --- APPLY MAIN IRIDESCENCE BEFORE COMPOSITION ---
        if (enable_main_iridescence) {
            vec3 irid_view = vec3(0.0, 0.0, 1.0);
            float mouse_fade_cap = 1.0;
            float mouse_fade_bevel = 1.0;
            
            if (enable_mouse_light) {
                float m_h = is_active ? active_mouse_light_height : inactive_mouse_light_height;
                vec3 mouse_vec = vec3((px - heat_dist_offset) - mouse_position, m_h);
                float m_len = length(mouse_vec);
                irid_view = m_len > 0.0001 ? (mouse_vec * (1.0 / m_len)) : vec3(0.0, 0.0, 1.0);
                
                if (main_irid_cap_mouse_fade) mouse_fade_cap = smoothstep(main_irid_cap_fade_range, 0.0, m_len);
                if (main_irid_bevel_mouse_fade) mouse_fade_bevel = smoothstep(main_irid_bevel_fade_range, 0.0, m_len);
            }
            
            float main_dot = max(0.0, dot(normal, irid_view)); 
            
            float cap_cf_mask = 1.0;
            float bev_cf_mask = 1.0;
            if (carbon_fiber_intensity > 0.0) {
                float mask_val = cf_normalized > 0.5 ? 1.0 : 0.0;
                if (carbon_fiber_masks_iridescence == 1) { cap_cf_mask = mask_val; bev_cf_mask = mask_val; }
                else if (carbon_fiber_masks_iridescence == 2) { cap_cf_mask = mask_val; }
                else if (carbon_fiber_masks_iridescence == 3) { bev_cf_mask = mask_val; }
            }
            
            float stamp_exclusion_mask = 1.0;
            if (main_irid_exclude_stamp1) stamp_exclusion_mask -= stamp1_exclusion;
            if (main_irid_exclude_stamp2) stamp_exclusion_mask -= stamp2_exclusion;
            stamp_exclusion_mask = clamp(stamp_exclusion_mask, 0.0, 1.0);
            
            if (main_irid_cap_intensity > 0.0 && bevel_factor < 1.0 && mouse_fade_cap > 0.0) {
                vec3 irid_color_cap = eval_iridescence(main_dot, main_irid_cap_scale, main_irid_cap_saturation, main_irid_cap_use_gradient, main_irid_cap_gradient);
                cap_final.rgb += irid_color_cap * main_irid_cap_intensity * mouse_fade_cap * cap_cf_mask * stamp_exclusion_mask;
            }
            
            if (main_irid_bevel_intensity > 0.0 && bevel_factor > 0.0 && mouse_fade_bevel > 0.0) {
                vec3 irid_color_bevel = eval_iridescence(main_dot, main_irid_bevel_scale, main_irid_bevel_saturation, main_irid_bevel_use_gradient, main_irid_bevel_gradient);
                lit_side_color += irid_color_bevel * main_irid_bevel_intensity * mouse_fade_bevel * bev_cf_mask * stamp_exclusion_mask;
            }
        }

        final_color = mix(cap_final, vec4(lit_side_color, bevel_opacity), bevel_factor);
        vec4 glaze_color = vec4(fresnel_color.rgb * fresnel, fresnel * (environment_reflectivity + current_metallic * 0.5)) + vec4(vec3(spec), spec * 0.5); 
        
        if (enable_mouse_light) {
            vec4 current_m_color = is_active ? active_mouse_light_color : inactive_mouse_light_color;
            float current_m_intensity = is_active ? active_mouse_light_intensity : inactive_mouse_light_intensity;
            float current_m_range = is_active ? active_mouse_light_range : inactive_mouse_light_range;
            float current_m_height = is_active ? active_mouse_light_height : inactive_mouse_light_height;

            vec3 mouse_light_vec = vec3((px - heat_dist_offset) - mouse_position, current_m_height);
            float mouse_dist = length(mouse_light_vec);
            if (mouse_dist < current_m_range && current_m_intensity > 0.0) {
                float mouse_attenuation = smoothstep(current_m_range, 0.0, mouse_dist);
                vec3 mouse_dir_norm = mouse_light_vec * (1.0 / max(0.001, mouse_dist));
                
                vec3 m_half = safe_normalize(mouse_dir_norm + vec3(0.0, 0.0, 1.0));
                float m_spec_dot = max(0.0, dot(normal, m_half));
                float m_spec = (m_spec_dot > 0.0) ? (pow(m_spec_dot, shininess) * specular_intensity) : 0.0;
                
                final_color.rgb += (current_m_color.rgb * max(0.0, dot(normal, mouse_dir_norm)) + vec3(m_spec)) * mouse_attenuation * current_m_intensity;
            }
        }
        
        final_color.rgb += glaze_color.rgb;
        final_color.a = clamp(mix(cap_final.a, bevel_opacity, bevel_factor) + (glaze_color.a * active_smoothness), 0.0, 1.0);
        final_color.a *= alpha_mask;
    }

    // --- APPLY POST PROCESSING MATH ---
    if (global_hue_shift != 0.0) {
        final_color.rgb = apply_hue_shift(final_color.rgb, global_hue_shift);
    }
    
    if (global_saturation != 1.0 || global_vibrance != 0.0) {
        float current_lum = dot(final_color.rgb, vec3(0.299, 0.587, 0.114));
        if (global_saturation != 1.0) {
            final_color.rgb = mix(vec3(current_lum), final_color.rgb, global_saturation);
        }
        if (global_vibrance != 0.0) {
            float max_c = max(max(final_color.r, final_color.g), final_color.b);
            float min_c = min(min(final_color.r, final_color.g), final_color.b);
            float pixel_sat = max_c - min_c;
            final_color.rgb = mix(vec3(current_lum), final_color.rgb, 1.0 + (global_vibrance * (1.0 - pixel_sat)));
        }
    }

    final_color.rgb = clamp((final_color.rgb - 0.5) * global_contrast + 0.5 + global_brightness, 0.0, 1.0);

    COLOR = final_color;
}